# AerisWeatherCodingChallenge

## Build Instructions

1. Fill in your [AerisWeather](https://www.aerisweather.com/) SDK [client ID & client secret](https://account.aerisweather.com/account/apps) in `Sources/App/Secret.swift`.
2. Fill in your [StadiaMaps](https://stadiamaps.com/) SDK [API key](https://client.stadiamaps.com/dashboard/#/overview) in `Sources/App/Secret.swift`.
3. Open `AerisWeatherCodingChallenge.xcodeproj` and under the App target, Signing & Capabilities tab, change the Team to your development provisioning team.
4. Build & Run!


## Libraries Used

* [apple/swift-collections](https://github.com/apple/swift-collections), for use of `OrderedSet`
* [capnslipp/DTMHeatmap](https://github.com/capnslipp/DTMHeatmap) _(a fork of [onurersel/DTMHeatmap](https://github.com/onurersel/DTMHeatmap), which is a fork of [dataminr/DTMHeatmap](https://github.com/dataminr/DTMHeatmap))_ for heatmap display in Apple Maps.