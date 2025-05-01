# Usa la imagen oficial de .NET SDK para construir la aplicación
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Copia el archivo del proyecto y restaura las dependencias
COPY EvaluacionContinua2/*.csproj ./EvaluacionContinua2/
RUN dotnet restore ./EvaluacionContinua2/EvaluacionContinua2.csproj

# Copia el resto de los archivos y compila la aplicación
COPY . ./
RUN dotnet publish ./EvaluacionContinua2/EvaluacionContinua2.csproj -c Release -o out

# Usa la imagen oficial de .NET Runtime para ejecutar la aplicación
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/out .

# Configura la variable de entorno para el nombre del archivo DLL
ENV APP_NET_CORE EvaluacionContinua2.dll

# Configura el puerto y ejecuta la aplicación
ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80
CMD ["dotnet", "EvaluacionContinua2.dll"]