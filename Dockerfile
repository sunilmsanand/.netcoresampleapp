FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5158

ENV ASPNETCORE_URLS=http://+:5158

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY [".Net App.csproj", "./"]
RUN dotnet restore ".Net App.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build ".Net App.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish ".Net App.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", ".Net App.dll"]
