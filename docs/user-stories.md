# User stories — MorningCoffee

Wymagania funkcjonalne sklepu, spisane z perspektywy użytkownika.
Kryteria akceptacji powstają przed implementacją i stanowią definicję
ukończenia historii. Identyfikatory `E0-xx` odsyłają do backlogu technicznego.

**Zakres:** faza 0 — MVP.

---

# EPIK 1: Katalog produktów

## Historia 1.1 — Przeglądanie oferty

**Jako** gość odwiedzający sklep
**chcę** zobaczyć listę dostępnych kaw
**żeby** ocenić, czy jest tu coś dla mnie.

**Kryteria akceptacji:**

- [ ] Na stronie katalogu widzę kawy z nazwą, krajem pochodzenia,
      stopniem wypału, oceną i ceną
- [ ] Widzę jednocześnie nie więcej niż 12 pozycji
- [ ] Widzę, ile jest wszystkich kaw i na której stronie jestem
- [ ] Mogę przejść do kolejnej strony i wrócić do poprzedniej
- [ ] Kawy niedostępne są oznaczone, ale nie znikają z listy
- [ ] Nie muszę być zalogowany

**Poza zakresem:** wyszukiwanie po nazwie, zdjęcia produktów.

**Zadania:** E0-09, E0-09a, E0-10, E0-11, E0-16

---

## Historia 1.2 — Zawężanie wyboru

**Jako** gość
**chcę** ograniczyć listę do kaw z konkretnego kraju i ułożyć ją po cenie
**żeby** szybciej znaleźć to, co mnie interesuje.

**Kryteria akceptacji:**

- [ ] Mogę wybrać kraj pochodzenia i lista się zawęża
- [ ] Mogę uporządkować listę po cenie rosnąco i malejąco oraz po ocenie
- [ ] Wybrany filtr i sortowanie widać w adresie strony,
      więc mogę wysłać ten adres znajomemu
- [ ] Po zmianie filtra wracam na pierwszą stronę
- [ ] Gdy nic nie pasuje, widzę komunikat, a nie pustą stronę

**Zadania:** E0-10, E0-16

---

## Historia 1.3 — Poznanie konkretnej kawy

**Jako** gość
**chcę** otworzyć stronę wybranej kawy
**żeby** poznać jej opis, parametry i dostępne warianty przed zakupem.

**Kryteria akceptacji:**

- [ ] Widzę nazwę, opis, nuty smakowe, pochodzenie, wysokość uprawy,
      ocenę, profil wypału i liczbę dni od wypalenia
- [ ] Mogę wybrać stopień zmielenia i gramaturę
- [ ] Cena zmienia się po zmianie gramatury
- [ ] Widzę, czy wybrany wariant jest dostępny
- [ ] Adres strony zawiera czytelną nazwę kawy, nie numer
- [ ] Nieistniejąca kawa daje komunikat, nie błąd aplikacji

**Zadania:** E0-09, E0-12, E0-17

---

# EPIK 2: Konto użytkownika

## Historia 2.1 — Założenie konta

**Jako** gość
**chcę** założyć konto podając adres e-mail i hasło
**żeby** móc składać zamówienia i wracać do historii zakupów.

**Kryteria akceptacji:**

- [ ] Zakładam konto podając adres e-mail i hasło
- [ ] Hasło krótsze niż 8 znaków jest odrzucane z czytelnym komunikatem
- [ ] Adres w niepoprawnym formacie jest odrzucany przed wysłaniem formularza
- [ ] Próba rejestracji na zajęty adres kończy się komunikatem,
      a nie utworzeniem drugiego konta
- [ ] Po udanej rejestracji jestem zalogowany i nie muszę logować się osobno
- [ ] Nowe konto ma uprawnienia klienta, nigdy administratora

**Poza zakresem:** potwierdzanie adresu e-mail, logowanie przez Google.

**Zadania:** E0-18, E0-21, E0-23

---

## Historia 2.2 — Logowanie

**Jako** zarejestrowany klient
**chcę** zalogować się na swoje konto
**żeby** uzyskać dostęp do koszyka i historii zamówień.

**Kryteria akceptacji:**

- [ ] Loguję się adresem e-mail i hasłem
- [ ] Błędne dane dają jeden ogólny komunikat, bez wskazywania,
      czy pomyliłem hasło, czy konto nie istnieje
- [ ] Po zalogowaniu wracam na stronę, z której przyszedłem
- [ ] Widzę, że jestem zalogowany, na każdej podstronie sklepu
- [ ] Po kilku nieudanych próbach kolejne są chwilowo blokowane

**Zadania:** E0-19, E0-20, E0-22, E0-23

---

## Historia 2.3 — Utrzymanie sesji

**Jako** zalogowany klient
**nie chcę** logować się ponownie po odświeżeniu strony ani po powrocie
następnego dnia
**żeby** korzystanie ze sklepu nie było uciążliwe.

**Kryteria akceptacji:**

- [ ] Odświeżenie strony nie wylogowuje mnie
- [ ] Zamknięcie i ponowne otwarcie przeglądarki nie wylogowuje mnie
- [ ] Po dłuższej nieaktywności sesja wygasa i widzę prośbę o zalogowanie
- [ ] Wygaśnięcie sesji nie kasuje zawartości mojego koszyka

**Zadania:** E0-19, E0-23

---

## Historia 2.4 — Wylogowanie

**Jako** zalogowany klient
**chcę** wylogować się jednym kliknięciem
**żeby** nikt korzystający z tego samego urządzenia nie miał dostępu
do mojego konta.

**Kryteria akceptacji:**

- [ ] Po wylogowaniu nie mam dostępu do historii zamówień
- [ ] Cofnięcie się w przeglądarce nie przywraca dostępu do stron
      wymagających zalogowania
- [ ] Po wylogowaniu ląduję na stronie głównej

**Zadania:** E0-19, E0-23

---

# EPIK 3: Koszyk

## Historia 3.1 — Dodanie kawy do koszyka

**Jako** klient
**chcę** dodać wybrany wariant kawy do koszyka
**żeby** zebrać zamówienie przed zakupem.

**Kryteria akceptacji:**

- [ ] Dodaję kawę wskazując stopień zmielenia i gramaturę
- [ ] Widzę potwierdzenie dodania bez opuszczania strony produktu
- [ ] Licznik przy koszyku aktualizuje się natychmiast
- [ ] Ponowne dodanie tego samego wariantu zwiększa ilość,
      zamiast tworzyć drugą pozycję
- [ ] Nie mogę dodać wariantu oznaczonego jako niedostępny

**Zadania:** E0-26, E0-27, E0-32

---

## Historia 3.2 — Przegląd i zmiana zawartości

**Jako** klient
**chcę** zobaczyć zawartość koszyka i ją zmienić
**żeby** upewnić się, że zamawiam to, czego chcę.

**Kryteria akceptacji:**

- [ ] Widzę każdą pozycję z nazwą, wariantem, ilością i ceną
- [ ] Widzę wartość zamówienia i koszt dostawy
- [ ] Mogę zmienić ilość i usunąć pozycję
- [ ] Kwota przelicza się po każdej zmianie
- [ ] Pusty koszyk pokazuje komunikat i odnośnik do katalogu

**Zadania:** E0-26, E0-32

---

## Historia 3.3 — Powrót do koszyka

**Jako** zalogowany klient
**chcę** zastać swój koszyk nienaruszony po powrocie
**żeby** nie kompletować zamówienia od nowa.

**Kryteria akceptacji:**

- [ ] Po ponownym zalogowaniu koszyk zawiera to, co przed wyjściem
- [ ] Koszyk jest ten sam niezależnie od urządzenia
- [ ] Jeśli w międzyczasie zmieniła się cena, widzę aktualną
      i jestem o tym poinformowany

**Zadania:** E0-26, E0-32

---

# EPIK 4: Zamówienie

## Historia 4.1 — Złożenie zamówienia

**Jako** zalogowany klient
**chcę** złożyć zamówienie na zawartość koszyka
**żeby** otrzymać kawę.

**Kryteria akceptacji:**

- [ ] Podaję adres dostawy przed potwierdzeniem
- [ ] Widzę podsumowanie z pozycjami i pełną kwotą przed zatwierdzeniem
- [ ] Po złożeniu zamówienia koszyk jest pusty
- [ ] Zamówienie dostaje numer, który widzę na ekranie
- [ ] Podwójne kliknięcie przycisku nie tworzy dwóch zamówień
- [ ] Ceny w zamówieniu nie zmieniają się później, nawet gdy zmieni się
      cennik sklepu

**Zadania:** E0-28, E0-30, E0-32

---

## Historia 4.2 — Nieudany zakup

**Jako** klient, którego zamówienie nie doszło do skutku
**chcę** wiedzieć, co się stało i co mogę zrobić
**żeby** nie zostać z poczuciem, że straciłem pieniądze.

**Kryteria akceptacji:**

- [ ] Gdy ostatnia paczka zostanie kupiona w tej samej chwili przez kogoś
      innego, widzę zrozumiały komunikat, a nie błąd aplikacji
- [ ] Zawartość koszyka pozostaje nienaruszona
- [ ] Zamówienie nie powstaje, a stan magazynowy pozostaje spójny
- [ ] Widzę, której pozycji dotyczy problem

**Zadania:** E0-28, E0-31

---

## Historia 4.3 — Śledzenie realizacji

**Jako** klient
**chcę** sprawdzić, na jakim etapie jest moje zamówienie
**żeby** wiedzieć, kiedy spodziewać się przesyłki.

**Kryteria akceptacji:**

- [ ] Widzę aktualny status: przyjęte, opłacone, wypalane, wysłane
- [ ] Widzę datę złożenia i zamówione pozycje
- [ ] Nie mam dostępu do zamówień innych klientów, nawet znając ich numer

**Zadania:** E0-29, E0-32

---

## Historia 4.4 — Historia zakupów

**Jako** powracający klient
**chcę** przejrzeć swoje wcześniejsze zamówienia
**żeby** przypomnieć sobie, która kawa mi smakowała.

**Kryteria akceptacji:**

- [ ] Widzę listę zamówień od najnowszego
- [ ] Każda pozycja pokazuje numer, datę, kwotę i status
- [ ] Mogę otworzyć szczegóły dowolnego zamówienia
- [ ] Brak zamówień pokazuje komunikat, nie pustą stronę

**Zadania:** E0-29, E0-32

---

# EPIK 5: Zarządzanie sklepem

## Historia 5.1 — Wprowadzenie kawy do oferty

**Jako** właściciel palarni
**chcę** dodać nową kawę wraz z jej wariantami
**żeby** pojawiła się w sklepie po zakończeniu wypału.

**Kryteria akceptacji:**

- [ ] Wprowadzam nazwę, opis, pochodzenie, parametry, wariantyi ceny
- [ ] Niekompletne dane są odrzucane ze wskazaniem brakującego pola
- [ ] Nowa kawa jest widoczna w katalogu natychmiast po zapisaniu
- [ ] Mogę edytować i wycofać kawę z oferty
- [ ] Wycofana kawa znika z katalogu, ale pozostaje w złożonych zamówieniach
- [ ] Klient bez uprawnień nie ma dostępu do tych funkcji

**Zadania:** E0-34, E0-36, E0-37

---

## Historia 5.2 — Aktualizacja stanu magazynowego

**Jako** właściciel palarni
**chcę** zaktualizować liczbę paczek po zakończonym wypale
**żeby** sklep nie sprzedawał kawy, której nie mam.

**Kryteria akceptacji:**

- [ ] Ustawiam liczbę dostępnych paczek osobno dla każdego wariantu
- [ ] Wariant z zerowym stanem jest oznaczony w katalogu jako niedostępny
- [ ] Widzę, które warianty mają niski stan
- [ ] Nie mogę wprowadzić wartości ujemnej

**Zadania:** E0-34, E0-36, E0-37

---

## Historia 5.3 — Obsługa zamówień

**Jako** właściciel palarni
**chcę** przeglądać zamówienia i zmieniać ich status
**żeby** klienci wiedzieli, co dzieje się z ich przesyłką.

**Kryteria akceptacji:**

- [ ] Widzę wszystkie zamówienia od najnowszego
- [ ] Widzę pozycje, kwotę, dane dostawy i status
- [ ] Zmieniam status, a klient widzi zmianę u siebie
- [ ] Nie mogę cofnąć statusu na wcześniejszy

**Zadania:** E0-35, E0-37
