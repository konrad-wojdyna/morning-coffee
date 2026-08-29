# ADR-003: Komunikacja przeglądarki z backendem

- **Data:** 2026-08-29

---

## Kontekst

Backend (Spring Boot) nasłuchuje na porcie 8080, frontend (Next.js)
na 3000. Dla przeglądarki są to dwa różne pochodzenia, więc obowiązuje
polityka tego samego pochodzenia: kod załadowany z jednego adresu
nie może odczytać odpowiedzi z drugiego bez wyraźnej zgody serwera.

Po wprowadzeniu logowania token uwierzytelniający trafi do ciasteczka `HttpOnly`.
Ciasteczko należy do adresu, który je ustawił, i przeglądarka wysyła je
wyłącznie pod ten adres. Decyzja podjęta teraz przesądza więc o tym,
czy strony wymagające zalogowania będą mogły być renderowane na serwerze.

## Rozważane opcje

**A. CORS — przeglądarka łączy się bezpośrednio z portem 8080.**
Backend odsyła nagłówek `Access-Control-Allow-Origin` z adresem frontendu.

**B. Next jako pośrednik — przeglądarka zna wyłącznie port 3000.**
Next przepisuje żądania spod `/api/*` na backend po stronie serwera.

## Decyzja

**Opcja B.**

Przesądza jeden argument. Przy opcji A ciasteczko z tokenem należy
do `localhost:8080`, więc przeglądarka nie wysyła go, prosząc serwer Next
o stronę. Serwer Next nie ma czym uwierzytelnić żądania do backendu,
przez co **każda strona wymagająca zalogowania musiałaby przestać być
komponentem serwerowym**. Wybieralibyśmy Next dla renderowania po stronie
serwera i jednocześnie odbierali sobie tę możliwość wszędzie tam,
gdzie jest logowanie.

Przy opcji B ciasteczko należy do `localhost:3000`, przeglądarka wysyła je
do serwera Next, a Next przekazuje je dalej do backendu.

## Konsekwencje

### Pozytywne

- Strony po zalogowaniu mogą być komponentami serwerowymi
- Ciasteczko jest własne (`SameSite=Lax`), brak potrzeby HTTPS lokalnie
- Token może być `HttpOnly` — niedostępny dla JavaScriptu w przeglądarce,
  co zamyka klasę ataków przez wstrzyknięty skrypt
- Brak zapytań wstępnych `OPTIONS` przed każdym nietrywialnym żądaniem
- Backend nie musi znać adresów, pod którymi stoi frontend

### Negatywne

- Dodatkowy przeskok sieciowy dla żądań z przeglądarki
- Serwer Next wchodzi na ścieżkę krytyczną — jego awaria odcina API
- Konfiguracja przepisywania w dwóch wariantach: lokalnym i produkcyjnym
- W logach backendu adres źródłowy to serwer Next, nie użytkownik.
  Wymaga przekazywania nagłówka `X-Forwarded-For`

## Uwaga wdrożeniowa

Przepisywanie dotyczy wyłącznie żądań wychodzących z przeglądarki.
Komponenty serwerowe wołają backend bezpośrednio, bo działają po tej samej
stronie sieci — reguła pochodzenia jest mechanizmem przeglądarki
i ich nie obowiązuje.

```ts
// next.config.ts
async rewrites() {
  return [{
    source: "/api/:path*",
    destination: `${process.env.BACKEND_URL}/api/:path*`,
  }];
}
```

`BACKEND_URL` w `.env.local`: `http://localhost:8080`

## Warunki rewizji

Decyzję należy przemyśleć ponownie, gdy pojawi się aplikacja mobilna
albo zewnętrzny klient API. Tacy klienci wymagają uwierzytelniania
tokenem w nagłówku zamiast ciasteczka, a wtedy CORS wraca do rozważań
dla tamtej grupy klientów — równolegle, nie zamiast.
