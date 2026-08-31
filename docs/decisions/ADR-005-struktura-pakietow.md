# ADR-005: Struktura pakietów w backendzie

- **Data:** 2026-08-31
- **Status:** Przyjęta

---

## Kontekst

Backend będzie zawierał kilka obszarów funkcjonalnych: katalog produktów,
konta użytkowników, koszyk, zamówienia i zarządzanie sklepem. Struktura
pakietów przesądza o tym, ile miejsc trzeba odwiedzić, realizując jedną
zmianę, oraz czy granice między obszarami da się egzekwować, czy pozostaną
wyłącznie umową.

Decyzja zapada teraz, ponieważ jej późniejsza zmiana oznacza przeniesienie
wszystkich klas i naprawę importów w całym projekcie.

Dokument dotyczy wyłącznie backendu. Struktura frontendu wynika z konwencji
narzuconych przez Next.js i nie pozostawia wyboru wymagającego udokumentowania.

## Rozważane opcje

### A. Podział według warstw technicznych

Pakiety odpowiadają roli klasy: `controller`, `service`, `repository`,
`entity`, `dto`.

**Za:**

- Układ powszechnie znany, spotykany w większości materiałów o Springu
- Przy jednym obszarze funkcjonalnym czytelniejszy — od razu widać
  wszystkie kontrolery aplikacji
- Nie wymaga rozstrzygania, do którego obszaru należy dana klasa

**Przeciw:**

- Realizacja jednej funkcjonalności wymaga zmian w czterech pakietach
- Wraz z rozwojem projektu pakiety rosną liniowo i przestają nieść
  informację — katalog z trzydziestoma serwisami niczego nie porządkuje
- Wszystkie klasy muszą być publiczne, ponieważ serwis z jednego pakietu
  korzysta z repozytorium z innego. Granice między obszarami nie istnieją
  na poziomie kompilacji

### B. Podział według obszarów funkcjonalnych

Pakiety odpowiadają obszarom dziedziny: `product`, `account`, `cart`,
`order`. Każdy zawiera własny kontroler, serwis, repozytorium i model.

**Za:**

- Wszystko potrzebne do jednej zmiany leży w jednym miejscu
- Dodanie obszaru to nowy pakiet, bez modyfikacji istniejących
- Usunięcie funkcjonalności to usunięcie katalogu
- Klasy wewnętrzne obszaru mogą być pakietowo-prywatne, więc granice
  są egzekwowane przez kompilator, a nie przez dyscyplinę
- Wydzielenie obszaru do osobnej usługi sprowadza się do przeniesienia
  pakietu

**Przeciw:**

- Wymaga rozstrzygania, gdzie umieścić kod używany przez kilka obszarów
- Przy jednym obszarze wprowadza podział bez korzyści
- Wymaga świadomego unikania zależności cyklicznych między pakietami

## Decyzja

**Opcja B: podział według obszarów funkcjonalnych.**

W układzie funkcjonalnym repozytorium produktów może pozostać pakietowo-prywatne i moduł zamówień
nie ma technicznej możliwości sięgnięcia po nie z pominięciem serwisu.

Wewnątrz każdego pakietu obowiązuje podział warstwowy z jednokierunkowym
przepływem: kontroler wywołuje serwis, serwis wywołuje repozytorium.
Pominięcie warstwy pośredniej jest niedopuszczalne.

Przy obecnym stanie projektu, z jednym obszarem
funkcjonalnym, układ warstwowy byłby czytelniejszy. Przewaga wybranej
opcji ujawni się dopiero przy trzecim i czwartym obszarze. Decyzja jest
podjęta z wyprzedzeniem, ponieważ jej późniejsza zmiana jest kosztowna.

Kod wspólny nie otrzymuje pakietu z góry. Zostanie wydzielony dopiero
wtedy, gdy dwa obszary będą realnie potrzebować tego samego kodu, a jego
umiejscowienie i nazwa zostaną ustalone w tamtym momencie. Utworzenie
takiego pakietu zawczasu prowadzi do gromadzenia w nim kodu, który
należy gdzie indziej.

## Konsekwencje

**Zmiana funkcjonalności dotyka jednego pakietu.** Skraca czas realizacji
zadania i ogranicza ryzyko przeoczenia miejsca wymagającego zmiany.

**Granice są wymuszane, nie umawiane.** Klasy nieprzeznaczone do użytku
poza obszarem pozostają pakietowo-prywatne. Wymaga to świadomego
oznaczania jako publiczne wyłącznie tego, co stanowi kontrakt obszaru.

**Komunikacja między obszarami wymaga reguł.** Obszar odwołuje się
do innego wyłącznie przez jego warstwę usługową, nigdy bezpośrednio
do repozytorium ani encji. Naruszenie tej zasady odtwarza problem,
który wybrany układ miał rozwiązać.

**Ryzyko zależności cyklicznych.** Dwa obszary wywołujące się wzajemnie
tworzą splot trudny do rozerwania. Rozwiązaniem jest wprowadzenie
zdarzenia zamiast bezpośredniego wywołania.

**Przygotowanie pod wydzielenie usługi.** Jeśli w przyszłości któryś
obszar zostanie wydzielony do osobnej aplikacji, granica pakietu
wyznacza linię cięcia.

## Warunki rewizji

Decyzję należy rozważyć ponownie, gdy:

- **Kod wspólny urośnie nieproporcjonalnie.** Jeśli znaczna część klas
  przestanie należeć do konkretnego obszaru, oznacza to, że granice
  zostały wyznaczone niezgodnie z rzeczywistą dziedziną.
- **Pojawią się zależności cykliczne**, których nie da się rozwiązać
  zdarzeniami ani przeniesieniem odpowiedzialności.
- **Obszar rozrośnie się na tyle**, że sam będzie wymagał wewnętrznego
  podziału. Rozwiązaniem jest wówczas podział tego obszaru,
  a nie porzucenie całego układu.
