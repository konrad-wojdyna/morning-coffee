# ADR-002: Baza danych w testach integracyjnych

- **Data:** 2026-08-29

---

## Kontekst

Testy integracyjne muszą sprawdzać zachowanie warstwy dostępu do danych:
zapytania, migracje, transakcje, a w fazie 1 również blokady i zachowanie
przy równoczesnym zapisie.

Potrzebna jest baza, która powstaje na czas testów i znika po nich,
oraz gwarancja, że test nigdy nie połączy się z bazą deweloperską.
Jeden test czyszczący tabelę oznaczałby utratę danych, na których
pracujemy.

Środowisko musi działać identycznie lokalnie i na maszynie CI.

## Rozważane opcje

**H2 w pamięci** — startuje natychmiast, nie wymaga niczego poza JVM.
Jest jednak innym silnikiem niż produkcyjny: inaczej obsługuje typy,
inaczej blokady, część składni PostgreSQL jest niedostępna.

**Współdzielona baza testowa w Docker Compose** — prawdziwy PostgreSQL
na osobnym porcie. Wymaga ręcznego czyszczenia między przebiegami
i pozostawia ryzyko pomylenia portów.

**Testcontainers** — biblioteka uruchamiająca kontener Dockera na czas
testów. Kontener dostaje losowy port, żyje przez sesję testową i jest
usuwany po jej zakończeniu.

## Decyzja

**Testcontainers z adnotacją `@ServiceConnection`.**

Testujemy na tym samym silniku i tej samej wersji co produkcja, więc
test wykrywa problemy specyficzne dla PostgreSQL zamiast je maskować.
Ma to znaczenie już przy migracjach, a decydujące znaczenie w fazie 1,
gdzie badane będą blokady — zachowanie, którego H2 nie odwzorowuje.

`@ServiceConnection` sprawia, że adres i dane logowania podstawiane są
automatycznie w chwili startu kontenera. Dzięki temu profil testowy
nie zawiera adresu bazy, a test **fizycznie nie ma jak** połączyć się
z bazą deweloperską.

## Konsekwencje

### Pozytywne

- Test weryfikuje również migracje Flyway — błędna migracja przewraca
  testy, a nie dopiero wdrożenie
- Brak adresu w konfiguracji testowej eliminuje ryzyko pomyłki środowiska
- Ten sam mechanizm działa lokalnie i na CI bez zmian w konfiguracji

### Negatywne

- Start kontenera wydłuża pierwszy test o kilkanaście sekund
- Docker staje się wymogiem uruchomienia testów
- Przy większej liczbie klas testowych trzeba świadomie dbać o ponowne
  użycie kontenera, inaczej czas przebiegu rośnie

## Warunki rewizji

Gdy czas przebiegu testów na CI przekroczy kilka minut, rozwiązaniem
jest podział na testy jednostkowe bez bazy i integracyjne z bazą,
a nie rezygnacja z Testcontainers.
