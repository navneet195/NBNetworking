# NBNetworking

Networking/Service Layer

A librabry to maintain common network call for all application platform iOS app.

I had to make more customizable and reusable Networking layer for each project.
Networking/Service layer consists of all the objects that do external communication in your ios app. you have an HTTP client and service objects that inject that client and use it to communicate with your’s backend API. Services also compose new request objects (create HTTP headers, params, sign and encrypt them, etc.), receive JSON/XML responses, and parse and map the responses to domain model objects.

--------------------------

All Take status as per requirement: All Finished

Add NetworkClient tests case for.
```
    func getCurrencyExchangeRates(url: String) -> AnyPublisher<currencyExchangeRatesModel, NBURLSessionError> {
        if let result = rates {
            getRatesCount = result.rates.count
            return Just(result)
                .setFailureType(to: NBURLSessionError.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: NBURLSessionError.responseError)
            .eraseToAnyPublisher()
    }
```

```
    private var bag = Set<AnyCancellable>()
```

```
    func getCurrencyExchangeRatesData() {
            service.getCurrencyExchangeRates(url: AppConstants.exchangeratesURL)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    guard let self = self else { return }
                    switch completion {
                    case .finished:
                        debugPrint("Get exchange rates...")
                    case .failure(let error):
                        debugPrint("API Fail \(error)")
                      
                    }
                } receiveValue: { [weak self] exchangeRates in
                    guard let self = self else { return }
                    self.rates = exchangeRates.rates
                }
                .store(in: &bag)
    }
```

