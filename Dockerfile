FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /app 
#
# copy csproj and restore as distinct layers
COPY *.sln .
COPY API-Gateway/*.csproj ./API-Gateway/
#
RUN dotnet restore 
#
# copy everything else and build app
COPY API-Gateway/. ./API-Gateway/
#
WORKDIR /app/API-Gateway
RUN dotnet publish -c Release -o out 
#
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS runtime
WORKDIR /app 
#
COPY --from=build /app/API-Gateway/out ./

EXPOSE 80
ENTRYPOINT ["dotnet", "API-Gateway.dll"]