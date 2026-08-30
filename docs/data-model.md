# Model danych — MorningCoffee

Opis bytów dziedzinowych, schemat bazy i uzasadnienie decyzji modelowych.

**Stan:** schemat obejmuje kawy i ich warianty. Koszyk, klienci i zamówienia
są opisane w modelu pojęciowym, ale ich tabele powstaną w kolejnych etapach.

---

## Model pojęciowy

Byty wynikają z historii użytkownika opisanych w `user-stories.md`.

| Byt                    | Opis                                                                                                                                                  |
| ---------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Kawa**               | Konkretne ziarno od konkretnego producenta. Ma pochodzenie, obróbkę, wysokość uprawy, ocenę i nuty smakowe. Sama w sobie nie jest przedmiotem zakupu. |
| **Wariant**            | Kawa w konkretnej postaci: stopień zmielenia i gramatura. Jedyny byt, który da się kupić. Ma własną cenę i własny stan magazynowy.                    |
| **Klient**             | Osoba z kontem w sklepie.                                                                                                                             |
| **Koszyk**             | Zbiór tego, co klient zamierza kupić. Zmienny, bez skutków prawnych. Należy do klienta albo do niezalogowanego gościa.                                |
| **Pozycja koszyka**    | Wskazanie wariantu wraz z ilością.                                                                                                                    |
| **Zamówienie**         | Moment, w którym zamiar staje się zobowiązaniem. Ma numer, status, adres dostawy i kwotę.                                                             |
| **Pozycja zamówienia** | Zapis tego, co i za ile zostało kupione.                                                                                                              |

### Związki

- Jedna kawa ma jeden lub więcej wariantów. Wariant należy do dokładnie jednej kawy.
- Jeden klient ma jeden koszyk. Koszyk może również należeć do niezalogowanego gościa.
- Koszyk zawiera wiele pozycji, każda wskazuje na jeden wariant.
- Jeden klient składa wiele zamówień. Zamówienie należy do jednego klienta.
- Zamówienie zawiera jedną lub więcej pozycji.

---

## Schemat — kawy i warianty

```mermaid
erDiagram
    PRODUCT ||--|{ PRODUCT_VARIANT : "occurs in"

    PRODUCT {
        bigint id PK
        varchar(120) name
        varchar(140) slug UK
        text description
        varchar(60) origin_country
        varchar(80) farm
        varchar(30) process
        int altitude_masl
        numeric(4_1) cupping_score
        smallint roast_level
        varchar(200) flavour_notes
        date roasted_on
        timestamptz discontinued_at
        timestamptz created_at
        timestamptz updated_at
    }

    PRODUCT_VARIANT {
        bigint id PK
        bigint product_id FK
        varchar(20) grind
        int weight_grams
        int price_gross
        int stock_quantity
        boolean active
        timestamptz created_at
        timestamptz updated_at
    }
```

---

## Ograniczenia

Ograniczenia wyrażają reguły dziedziny i są egzekwowane przez bazę danych.
Sprawdzenie w kodzie aplikacji jest uzupełnieniem służącym czytelnym
komunikatom, nigdy zamiennikiem — dane mogą trafić do bazy również
z migracji, skryptu lub konsoli administracyjnej.

### Kawa

| Kolumna                                | Ograniczenie              | Uzasadnienie                                                                                        |
| -------------------------------------- | ------------------------- | --------------------------------------------------------------------------------------------------- |
| `name`                                 | wymagana                  | Kawa bez nazwy nie może zostać przedstawiona w katalogu                                             |
| `slug`                                 | wymagany, unikalny        | Identyfikuje kawę w adresie strony. Powtórzenie uniemożliwiłoby rozstrzygnięcie, którą kawę pokazać |
| `origin_country`                       | wymagany                  | Kryterium akceptacji historii 1.1 i podstawa filtrowania w historii 1.2                             |
| `process`                              | wymagana                  | Podstawowa informacja o ziarnie, oczekiwana przez kupujących kawę specialty                         |
| `roast_level`                          | wymagany, od 1 do 3       | Kryterium akceptacji historii 1.1. Zakres odpowiada trzem stopniom wypału                           |
| `roasted_on`                           | wymagana                  | Podstawa wyliczenia świeżości. Bez niej nie da się spełnić historii 1.3                             |
| `altitude_masl`                        | dodatnia, jeśli podana    | Wysokość ujemna lub zerowa nie ma sensu fizycznego                                                  |
| `cupping_score`                        | od 0 do 100, jeśli podana | Skala oceny sensorycznej                                                                            |
| `description`, `farm`, `flavour_notes` | opcjonalne                | Nie zawsze dostępne od dostawcy, brak nie blokuje sprzedaży                                         |

### Wariant

| Kolumna                             | Ograniczenie                     | Uzasadnienie                                                                                                  |
| ----------------------------------- | -------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| `product_id`                        | wymagany, klucz obcy             | Wariant nie istnieje samodzielnie — jest postacią konkretnej kawy                                             |
| `grind`, `weight_grams`             | wymagane                         | Definiują wariant. Bez nich nie wiadomo, co klient kupuje                                                     |
| `weight_grams`                      | dodatnia                         | Opakowanie o zerowej lub ujemnej masie nie istnieje                                                           |
| `price_gross`                       | wymagana, dodatnia               | Sklep nie prowadzi sprzedaży darmowej ani ujemnej                                                             |
| `stock_quantity`                    | wymagana, nieujemna, domyślnie 0 | Stan ujemny oznaczałby sprzedaż towaru, którego nie ma. Kryterium historii 5.2                                |
| `active`                            | wymagana, domyślnie prawda       | Nowy wariant jest dostępny, dopóki nie zostanie wyłączony                                                     |
| `(product_id, grind, weight_grams)` | unikalna                         | Bez tego możliwe byłoby utworzenie dwóch identycznych wariantów tej samej kawy, różniących się wyłącznie ceną |

### Zachowanie klucza obcego

Klucz obcy z wariantu na kawę **nie usuwa kaskadowo**. Kawy nie usuwa się
z bazy — jest wycofywana. Próba usunięcia ma zakończyć się błędem,
a nie cichym usunięciem powiązanych wariantów.

---

## Decyzje modelowe

### Wariant jest przedmiotem zakupu

Cena i stan magazynowy należą do wariantu, nie do kawy, ponieważ kupuje się
konkretne opakowanie o konkretnym zmieleniu. Cechy ziarna — pochodzenie,
obróbka, wysokość, ocena — należą do kawy, bo nie zmieniają się wraz
z gramaturą. Umieszczenie ich na wariancie powielałoby te same wartości
w każdej kombinacji zmielenia i wagi, co prowadzi do rozbieżności
przy aktualizacji.

### Kwoty w groszach

`price_gross` przechowuje grosze: wartość `5490` oznacza 54,90 zł.
Uzasadnienie i konsekwencje opisuje ADR-004.

### Cena kawy na liście katalogu

Kawa nie ma własnej ceny — cena należy do wariantu. Na liście katalogu
prezentowana jest cena najniższa spośród aktywnych wariantów. Ta sama
wartość służy do sortowania listy po cenie.

Wartość jest wyliczana z tabeli wariantów, nie przechowywana. To samo
dotyczy dostępności kawy, która oznacza, że co najmniej jeden wariant
ma dodatni stan magazynowy.

Konsekwencja: zapytanie o listę kaw musi pobierać te wartości jednym
zapytaniem z agregacją. Wyliczanie ich osobno dla każdej pozycji
prowadziłoby do wielokrotnego odpytywania bazy przy jednym żądaniu.

### Dwa niezależne poziomy dostępności

`PRODUCT.discontinued_at` oznacza wycofanie kawy z oferty w całości.
`PRODUCT_VARIANT.active` oznacza rezygnację z konkretnego opakowania,
przy zachowaniu pozostałych. Są to odrębne decyzje handlowe, więc mają
odrębne pola.

### Wycofanie zamiast usunięcia

Kawy nie usuwa się z bazy. Wycofana pozostaje widoczna w złożonych wcześniej
zamówieniach — usunięcie rozerwałoby zapisy historyczne. Zapytania katalogu
pomijają rekordy z ustawionym `discontinued_at`.

Wynika to wprost z kryterium akceptacji historii 5.1.

### Znacznik czasu zamiast flagi logicznej

`discontinued_at` przechowuje moment wycofania, a wartość pusta oznacza
kawę dostępną. Zajmuje tyle samo miejsca co wartość logiczna,
a niesie dodatkową informację.

### Data wypału zamiast liczby dni

Przechowywana jest `roasted_on`, a liczba dni od wypału wyliczana przy
odczycie. Wartość wyliczalna, która zmienia się z upływem czasu, nie może
być przechowywana — wymagałaby codziennej aktualizacji wszystkich rekordów.

### Znaczniki czasu ze strefą

Wszystkie kolumny czasowe używają `timestamptz`. Typ bez strefy jest
niejednoznaczny, gdy serwer i klienci znajdują się w różnych strefach
lub gdy następuje zmiana czasu. `roasted_on` jest wyjątkiem — to data
dzienna, godzina nie ma tu znaczenia biznesowego.

### Ocena jako typ dziesiętny

`cupping_score` używa `numeric(4,1)`, mimo że kwoty przechowujemy jako
liczby całkowite. Na ocenie nie są wykonywane działania arytmetyczne —
jest przechowywana i wyświetlana, więc ryzyko błędów zaokrągleń
nie występuje.

### Stopień wypału jako liczba

`roast_level` przyjmuje wartości od 1 do 3. Typ wyliczeniowy PostgreSQL
byłby czytelniejszy, ale jego rozszerzenie wymaga migracji blokującej
tabelę. Liczba z warunkiem poprawności pozostaje elastyczniejsza.

---

## Indeksy

Indeksy nie są opisane w tym dokumencie. Są decyzją wydajnościową
wynikającą ze zmierzonych zapytań, a nie z modelu dziedziny, i będą
zmieniać się niezależnie od niego.

Wyjątkiem jest indeks pod kluczem obcym `product_variant.product_id`,
który jest elementem struktury — PostgreSQL nie tworzy go automatycznie,
a każde pobranie wariantów kawy z niego korzysta.

---

## Świadomie pominięte

Zdjęcia produktów, płatności jako osobny byt, dostawcy, kupony rabatowe,
recenzje, subskrypcje.

Żaden z tych bytów nie występuje w historiach użytkownika dla obecnego
zakresu.
