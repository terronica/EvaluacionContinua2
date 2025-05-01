# Usa la imagen oficial de .NET SDK para construir la aplicación
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Copia el archivo de solución y el archivo del proyecto
COPY *.sln ./
COPY EvaluacionContinua2/*.csproj ./EvaluacionContinua2/

# Restaura las dependencias
RUN dotnet restore ./EvaluacionContinua2/EvaluacionContinua2.csproj

# Copia el resto de los archivos y compila la aplicación
COPY ./EvaluacionContinua2 ./EvaluacionContinua2
WORKDIR /app/EvaluacionContinua2
RUN dotnet publish -c Release -o /out

# Usa la imagen oficial de .NET Runtime para ejecutar la aplicación
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/EvaluacionContinua2/out .

# Configura el puerto y ejecuta la aplicación
ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80
CMD ["dotnet", "EvaluacionContinua2.dll"]