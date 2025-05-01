
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app


COPY EvaluacionContinua2.sln ./
COPY *.csproj ./

RUN dotnet restore


COPY . ./
RUN dotnet publish -c Release -o /app/out


FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/out .


ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80
CMD ["dotnet", "EvaluacionContinua2.dll"]