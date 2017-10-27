# build stage
FROM microsoft/aspnetcore-build AS build-env

WORKDIR /generator

# restore
COPY api/api.csproj ./api/
RUN dotnet restore api/api.csproj
COPY tests/tests.csproj ./tests/
RUN dotnet restore tests/tests.csproj

# but won't run after 1st time because of caching
#RUN ls -alR

# copy source
COPY . .

# test
RUN dotnet test tests/tests.csproj

# publish
RUN dotnet publish api/api.csproj -o /publish

# runtime stage (image)
FROM microsoft/aspnetcore 
COPY --from=build-env /publish /publish
WORKDIR /publish
ENTRYPOINT [ "dotnet","api.dll" ]


