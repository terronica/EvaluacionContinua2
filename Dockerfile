# Usa la imagen oficial de .NET SDK para construir la aplicación
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copia los archivos del proyecto al contenedor
COPY *.sln .
COPY EvaluacionContinua2/*.csproj ./EvaluacionContinua2/
RUN dotnet restore

# Copia el resto de los archivos y compila la aplicación
COPY EvaluacionContinua2/. ./EvaluacionContinua2/
WORKDIR /app/EvaluacionContinua2
RUN dotnet publish -c Release -o /out

# Usa la imagen oficial de .NET Runtime para ejecutar la aplicación
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /out ./

# Expone el puerto 80 para el tráfico HTTP
EXPOSE 80

# Comando para ejecutar la aplicación
ENTRYPOINT ["dotnet", "EvaluacionContinua2.dll"]