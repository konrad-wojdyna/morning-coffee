# ADR-004: Reprezentacja kwot pieniężnych

- **Data:** 2026-08-30
- **Status:** Przyjęta

---

## Kontekst

System przechowuje ceny wariantów produktów, wylicza wartość koszyka
i kwoty zamówień. Wymaganie podstawowe: kwoty nie mogą tracić dokładności
na żadnym etapie obliczeń — ani przy mnożeniu przez ilość, ani przy
sumowaniu pozycji.

Typy zmiennoprzecinkowe (`float`, `double`) zostały odrzucone bez rozważania.
Nie reprezentują dokładnie ułamków dziesiętnych, więc powtarzane operacje
kumulują błąd. Pozostaje wybór między typem dziesiętnym o stałej precyzji
a liczbą całkowitą w najmniejszej jednostce waluty.

## Rozważane opcje

### A. Typ dziesiętny — `BigDecimal` w kodzie, `numeric` w bazie

**Za:**

- Naturalna reprezentacja kwoty: `54.90` zapisane wprost
- Wbudowane tryby zaokrąglania dla dzielenia
- Brak ograniczenia zakresu

**Przeciw:**

- Każde dzielenie wymaga jawnego podania trybu zaokrąglania,
  a jego pominięcie kończy się wyjątkiem w czasie działania
- Brak przeciążania operatorów w Javie czyni wyrażenia arytmetyczne
  wielokrotnie dłuższymi
- Porównywanie wymaga `compareTo`, ponieważ `equals` uwzględnia skalę
  i uznaje `54.90` za różne od `54.9`

### B. Liczba całkowita groszy

Wszystkie kwoty jako wartości całkowite w najmniejszej jednostce waluty.
Wartość `5490` oznacza 54,90 zł.

**Za:**

- Arytmetyka na liczbach całkowitych jest dokładna z definicji
- Mnożenie przez ilość nie wprowadza zaokrągleń
- Prosta składnia i bezproblemowe mapowanie na typy bazy oraz JSON

**Przeciw:**

- Skala nie wynika z typu — programista musi pamiętać o mnożniku 100
- Ograniczony zakres wymaga świadomego doboru typu
- Ułamki grosza są niereprezentowalne

## Decyzja

**Opcja B: liczby całkowite groszy.**

Rozstrzyga charakter operacji. W sklepie dominuje mnożenie ceny przez ilość
i sumowanie pozycji — działania, w których liczby całkowite są dokładne
bez żadnych zastrzeżeń. Dzielenie występuje rzadko i tylko na krawędzi
systemu, gdzie sposób zaokrąglania i tak musi być określony świadomie.

**Dobór typów:**

| Zastosowanie                      | Typ    | Zakres                     |
| --------------------------------- | ------ | -------------------------- |
| Cena jednostkowa, wartość pozycji | `int`  | do ok. 21 mln zł           |
| Kwoty zbiorcze, sumy i raporty    | `long` | praktycznie nieograniczony |

Cena pojedynczej paczki nigdy nie zbliży się do granicy `int`. Sumy
narastające — obrót roczny, raporty wieloletnie — mogą, więc tam
stosujemy `long`.

Każda kolumna i pole przechowujące kwotę zawiera jednostkę w nazwie
albo w komentarzu migracji.

## Konsekwencje

**Wnętrze systemu nie zna złotówek.** Logika biznesowa, encje, zdarzenia
i komunikaty operują wyłącznie na groszach. Kwota 54,90 zł istnieje
wewnątrz systemu jako `5490` i w żadnym miejscu nie przyjmuje innej postaci.

**Przeliczenie następuje wyłącznie na krawędzi.** Przy odbiorze żądania
konwersja z formatu użytkownika na grosze dzieje się podczas deserializacji.
Przy budowie odpowiedzi formatowanie następuje w ostatnim możliwym momencie,
podczas serializacji.

**Dzielenie wymaga jawnej strategii.** Rozliczenia proporcjonalne, podatki
i rabaty procentowe muszą określać, co dzieje się z resztą — na przykład
przypisanie pozostałych groszy do ostatniej pozycji. Bez tego system
gubi grosze przy każdym podziale.

**Ryzyko pomyłki o dwa rzędy wielkości.** Wartość `54` zamiast `5400`
jest poprawna typologicznie i przejdzie bez ostrzeżenia. Zabezpieczeniem
są testy oraz konsekwentne nazewnictwo pól.

## Warunki rewizji

Decyzję należy rozważyć ponownie, jeśli pojawi się wymaganie obsługi
ułamków grosza — na przykład przy cenach hurtowych za gram albo
przy przeliczaniu walut o innej liczbie miejsc dziesiętnych. Wówczas
rozwiązaniem jest zmiana skali (przechowywanie tysięcznych części
jednostki), a nie porzucenie liczb całkowitych.
