# GeoTasks
 [task](https://github.com/netronixgroup/geo-tasks).

# Dependencies
    Erlang/OTP 21
    Elixir 1.8.1


# Run

## Get source code
    `git clone git@github.com:parallel588/geo_tasks.git`

## Fetch debs and compile
    `cd geo_tasks`
    `mix deps.get`

## Configure
    Copy `config/dev.secret.exs.example` to `config/dev.secret.exs` and enter your database credentials.

## Setup
    `mix ecto.setup`

## Run Server
    `mix run --no-halt`

## Testing

### Create task. (manager token)

```
    curl "http://localhost:4001/tasks" \
    -H "Authorization: npFjLbDy_3-njP4KLWTd5K64XqorAiwcMcfdKE1qgBecyeFZdT" \
    -H "Content-Type: application/json" \
    -X POST \
    -d '{"dropoff": {"lat": "36.124642", "long": "-115.171137"}, "pickup": {"lat": "36.174968", "long": "-115.137222"}}'


    >>> {"status":"ok","task":{"dropoff_point":{"lat":-115.171137,"long":36.124642},"id":1,"pickup_point":{"lat":-115.137222,"long":36.174968},"status":"new"}}%

```

### Get tasks (driver token)

```
    curl "http://localhost:4001/tasks?position[lat]=36.124404&position[long]=-115.172605"  -H "Authorization:  r9AlnQyHM9D34iv-lvGPYa41InCvxMoGpYfBOwHvblc7uHz8Ez"

    >>> {"status":"ok","tasks":[{"dropoff_point":{"lat":-115.171137,"long":36.124642},"id":1,"pickup_point":{"lat":-115.137222,"long":36.174968},"status":"new"},{"dropoff_point":{"lat":-115.171137,"long":36.124642},"id":2,"pickup_point":{"lat":-115.137222,"long":36.174968},"status":"new"},{"dropoff_point":{"lat":-115.171137,"long":36.124642},"id":3,"pickup_point":{"lat":-115.137222,"long":36.174968},"status":"assigned"}]}


```

### Assigns task (driver token)

 ```
    curl "http://localhost:4001/task/1" -H "Authorization: r9AlnQyHM9D34iv-lvGPYa41InCvxMoGpYfBOwHvblc7uHz8Ez" -H "Content-Type: application/json"  -X PUT  -d '{"status": "assigned"}'

    >>> {"status":"ok","task":{"dropoff_point":{"lat":-115.171137,"long":36.124642},"id":1,"pickup_point":{"lat":-115.137222,"long":36.174968},"status":"assigned"}}

```

### Done task (driver token)

 ```
    curl "http://localhost:4001/task/1" -H "Authorization: r9AlnQyHM9D34iv-lvGPYa41InCvxMoGpYfBOwHvblc7uHz8Ez" -H "Content-Type: application/json"  -X PUT  -d '{"status": "assigned"}'

    >>> {"status":"ok","task":{"dropoff_point":{"lat":-115.171137,"long":36.124642},"id":1,"pickup_point":{"lat":-115.137222,"long":36.174968},"status":"done"}}
