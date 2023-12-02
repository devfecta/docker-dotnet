# # ASP.Net
# # NOT Hosted
# FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
# WORKDIR /app
# #EXPOSE 80
# #EXPOSE 443

# FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
# WORKDIR /src
# COPY ["DockerApp.csproj", "."]
# RUN dotnet restore "DockerApp.csproj"
# COPY . .
# RUN dotnet build "DockerApp.csproj" -c Release -o /app/build

# FROM build AS publish
# RUN dotnet publish "DockerApp.csproj" -c Release -o /app/publish

# # FROM base AS final
# # WORKDIR /app
# # COPY --from=publish /app/publish .
# # ENTRYPOINT [ "dotnet", "DockerApp.dll" ]

# #FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8.1-20231114-windowsservercore-ltsc2022
# #WORKDIR /inetpub/wwwroot
# #COPY --from=publish /app/publish .
# #COPY ./bin/Release/PublishOutput/ /inetpub/wwwroot
# FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8.1-20231114-windowsservercore-ltsc2022 as final
# RUN powershell -NoProfile -Command Remove-Item -Recurse C:\inetpub\wwwroot\*
# WORKDIR /inetpub/wwwroot
# COPY --from=publish /app/publish .


# # Blazor Nginx
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY DockerApp.csproj .
RUN dotnet restore DockerApp.csproj
COPY . .
RUN dotnet build DockerApp.csproj -c Release -o /app/build

FROM build AS publish
RUN dotnet publish DockerApp.csproj -c Release -o /app/publish

FROM nginx:alpine AS final
WORKDIR /usr/share/nginx/html
COPY --from=publish /app/publish/wwwroot .
COPY nginx.conf /etc/nginx/nginx.conf


# #  IIS
#FROM mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2022 as final
#RUN powershell -NoProfile -Command Remove-Item -Recurse C:\inetpub\wwwroot\*
#WORKDIR /inetpub/wwwroot
#COPY --from=publish /app/publish/wwwroot .


