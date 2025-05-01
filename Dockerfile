# Usa la imagen oficial de .NET SDK para construir la aplicación
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Copia el archivo de solución y el archivo del proyecto
COPY EvaluacionContinua2.sln ./
COPY *.csproj ./

# Restaura las dependencias
RUN dotnet restore

# Copia el resto de los archivos y compila la aplicación
COPY . ./
RUN dotnet publish -c Release -o /out

# Usa la imagen oficial de .NET Runtime para ejecutar la aplicación
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/out .

# Configura el puerto y ejecuta la aplicación
ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80
CMD ["dotnet", "EvaluacionContinua2.dll"]