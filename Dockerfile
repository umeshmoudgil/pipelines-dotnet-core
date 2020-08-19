#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["pipelines-dotnet-core/pipelines-dotnet-core.csproj", "pipelines-dotnet-core/"]
RUN dotnet restore "pipelines-dotnet-core/pipelines-dotnet-core.csproj"
COPY . .
WORKDIR "/src/pipelines-dotnet-core"
RUN dotnet build "pipelines-dotnet-core.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "pipelines-dotnet-core.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "pipelines-dotnet-core.dll"]