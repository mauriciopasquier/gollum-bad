# Configura gollum para requerir usuario y contraseña si se intenta acceder a
# una ruta destructiva (editar, renombrar, crear, borrar, revertir y subir
# archivos).
#
# El usuario y el password se definen con las variables de entorno
# `gollum_usuario` y `gollum_password` al iniciar el demonio.
module Precious
  class App < Sinatra::Base
    helpers do
      def proteger!
        return if autorizada?

        # Si no está autorizada, frenarla inmediatamente devolviendo un 401
        headers['WWW-Authenticate'] = 'Basic realm="Spammers atras, atras, atras!"'
        halt 401, "Not authorized\n"
      end

      # Una persona está autorizada si la ruta no está protegida, o sabe el password
      def autorizada?
        ruta_protegida?(request.path_info) ? solicitar_credenciales : true
      end

      # Revisa si la ruta indicada se parece a la lista de rutas que no
      # permitimos a los spammers
      def ruta_protegida?(ruta)
        %w{/edit /uploadFile /create /delete /revert /rename}.any? do |prohibida|
          ruta.match prohibida
        end
      end

      # Pregunta password y contraseña mediante HTTP Basic Auth
      def solicitar_credenciales
        auth = Rack::Auth::Basic::Request.new(request.env)
        auth.provided? && auth.credentials && auth.credentials == [ENV['gollum_usuario'], ENV['gollum_password']]
      end
    end

    # Proteger las rutas antes de cada solicitud
    before do
      proteger!
    end
  end
end
