##Llamada a la API
begin

    using HTTP, JSON, DataFrames, StatsPlots, Dates
	url = "https://datos.cdmx.gob.mx/api/3/action/datastore_search?resource_id=ae2cd306-1aed-45a1-8ee4-3d0b0852ae4b&limit=400000"
	#Lectura de los datos de la URL
	resp = HTTP.get(url)
	#Estatus de la respuesta
	resp.status
end
##Data a Json
data=JSON.parse(String(resp.body))
#Obtener diccionarios con los datos
d=data["result"]["records"]
#Pasarlo a dataframe
df=vcat(DataFrame.(d)...)

##cambiar formato de fecha
df.fecha_toma_muestra=Dates.format.(DateTime.(df.fecha_toma_muestra, dateformat"yyyy-mm-ddTHH:MM:SS"), dateformat"yyyy-mm-dd")

#Gráfica
@df df plot(:fecha_toma_muestra, :tasa_positividad_cdmx, title="Tasa de positividad COVID-19 en Ciudad de México",
titlefont=font(15,color="white"),lc="#b38e5d", linewidth=2,ylabel="Tasa",
xlabel="Fecha de toma de muestra\n Fuente: @claudiodanielpc con datos de la Agencia Digital de Innovación Pública.",
bg = RGB(0.2, 0.2, 0.2), xrotation = 45, legend=false)


#Salvar
plot!(size=(1000,900))
savefig("postividad.png") 