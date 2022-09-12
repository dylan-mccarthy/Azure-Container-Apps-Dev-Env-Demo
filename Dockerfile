FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Deployments-Testing.csproj", "/src"]
RUN dotnet restore "Deployments-Testing.csproj"
COPY . .
WORKDIR "/src"
RUN dotnet build "Deployments-Testing.csproj" -c Release -o /app/build

FROM build as publish
RUN dotnet publish "Deployments-Testing.csproj" -c Release -o /app/publish

FROM base as final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT [ "dotnet", "Deployments-Testing.dll" ]