# ADR-001: Wybór bazy danych

- **Data:** 2026-08-29

---

## Kontekst

Sklep przechowuje dane silnie powiązane relacjami: kawa ma warianty,
klient ma zamówienia, zamówienie ma pozycje wskazujące na warianty.
Zapis zamówienia musi być atomowy — zmniejszenie stanu magazynowego
i utworzenie zamówienia albo dzieją się razem, albo wcale.

Przy testach obciążeniowych na milionie rekordów oraz symulacja
równoczesnych zakupów ostatnich sztuk z limitowanej parti, baza musi
udostępniać blokady i kontrolę współbieżności na poziomie wiersza.

## Rozważane opcje

**PostgreSQL** — relacyjna, transakcje ACID, blokady optymistyczne
i pesymistyczne, indeksy złożone i częściowe, typ JSONB dla danych
o luźnej strukturze.

**MySQL** — porównywalna funkcjonalnie dla naszych potrzeb, szerzej
spotykana w hostingu współdzielonym.

**MongoDB** — dokumentowa. Brak transakcji obejmujących wiele kolekcji
bez dodatkowej konfiguracji klastra, słabsze wsparcie dla zapytań
łączących dane z kilku miejsc.

**H2 w pamięci** — brak trwałości, rozważana wyłącznie dla testów

## Decyzja

**PostgreSQL 17.**

Model danych jest z natury relacyjny, a integralność między zamówieniem
a stanem magazynowym jest wymaganiem biznesowym, nie szczegółem
technicznym. Baza dokumentowa wymagałaby pilnowania spójności w kodzie
aplikacji — czyli przeniesienia odpowiedzialności tam, gdzie łatwiej
o błąd.

Nad MySQL przeważyły: dojrzalsza obsługa współbieżności przy zapisie,
indeksy częściowe przydatne przy filtrowaniu katalogu oraz JSONB,
który pozwoli przechowywać profil wypału bez tworzenia osobnej tabeli.

## Konsekwencje

### Pozytywne

- Transakcje obejmujące kilka tabel bez dodatkowej pracy
- Blokada optymistyczna dostępna od razu
- Schemat wymusza spójność — niemożliwe jest zamówienie
  wskazujące na nieistniejący wariant

### Negatywne

- Zmiana schematu wymaga migracji, więc dokładania pracy przy każdej
  zmianie modelu
- Dane o luźnej strukturze trzeba świadomie umieszczać w JSONB,
  inaczej rozrastają się kolumny
- Środowisko lokalne wymaga Dockera, nie wystarczy uruchomienie
  samej aplikacji

## Warunki rewizji

Decyzję należy rozważyć ponownie, jeśli pojawi się wymaganie
pełnotekstowego wyszukiwania po opisach produktów w skali, której
wbudowany mechanizm PostgreSQL nie obsłuży wydajnie. Wówczas rozwiązaniem
jest dołożenie wyspecjalizowanego indeksu obok bazy, a nie jej wymiana.
