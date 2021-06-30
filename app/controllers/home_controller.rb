class HomeController < ApplicationController
  def index
    require 'faraday'

    # llamada a una API para obtener un JSON
    response = Faraday.get 'https://run.mocky.io/v3/92854371-555e-4d83-97ae-2eb012749638'
    data = JSON.parse(response.body)

    # devuelve las personas mayores de edad
    personas_mayores_de_edad = data["persona"].select{ |v| v["fecha_nacimiento"] < "#{Date.today - 18.years}" }
    ids_mayores_de_edad = personas_mayores_de_edad.map{ |p| p["id"] }

    # devuelve los comunicados de las personas mayores de edad
    @comunicados_mayores_de_edad =  data["comunicado"].select{ |com| com if ids_mayores_de_edad.include?(com["creador_id"]) }
    ids_comunicados = @comunicados_mayores_de_edad.map{ |c| c["id"] }

    # número de adjuntos total de los comunicados
    @adjuntos_total = data["adjuntos"].count
  end
end