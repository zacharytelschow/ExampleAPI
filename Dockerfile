# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy project files and restore dependencies
COPY *.csproj .
RUN dotnet restore

# Copy everything else and build
COPY . .
RUN dotnet publish -c Release -o /app

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Expose the ports ASP.NET Core listens on in containers
EXPOSE 8080
EXPOSE 8081

COPY --from=build /app .

ENTRYPOINT ["dotnet", "ExampleAPI.dll"]
