# Гайд: собираем FirebreakJBKawaii.ipa через GitHub Actions (без своего мака)

GitHub даёт **бесплатный macOS-раннер** для публичных репозиториев. Ты
заливаешь исходники → GitHub сам компилирует в облаке → ты скачиваешь
готовый `.ipa` → закидываешь в SideStore. Никаких платных подписок.

Время: **~10 минут** на настройку, **~5 минут** на каждую сборку.

---

## Шаг 1: Регистрация на GitHub (если нет аккаунта)

1. Открой https://github.com/signup
2. Введи email, пароль, username
3. Подтверди email по ссылке из письма

Бесплатно, никакой карты не требуется.

---

## Шаг 2: Создание публичного репозитория

1. Зайди на https://github.com/new
2. **Repository name:** `Firebreak`
3. **Description:** `Sileo-style concept iOS app`
4. **Visibility:** ⚠️ **PUBLIC** (обязательно — иначе macOS-раннер платный)
5. ☑️ Add a README file
6. Нажми **Create repository**

---

## Шаг 3: Заливка исходников в репозиторий

Тебе нужно закинуть **содержимое** папки `Firebreak/` из архива
`FirebreakJBKawaii_source.zip` в корень репозитория.

### Способ A: через веб-интерфейс GitHub (проще)

1. Распакуй `FirebreakJBKawaii_source.zip` у себя на компе — появится папка `Firebreak`
2. Зайди в свой репозиторий на GitHub
3. Нажми **Add file → Upload files**
4. **Важно:** GitHub веб-интерфейс не загружает файлы из подпапок напрямую.
   Поэтому делай так:
   - Сначала нажми **Add file → Create new file**
   - Введи `.github/workflows/.gitkeep`, в содержимом напиши `placeholder`
   - Нажми **Commit changes**
   - Аналогично создай пустые файлы-заглушки для каждой вложенной папки:
     - `FirebreakJBKawaii/Models/.gitkeep`
     - `FirebreakJBKawaii/Views/.gitkeep`
     - `FirebreakJBKawaii/Components/.gitkeep`
     - `FirebreakJBKawaii/Assets.xcassets/.gitkeep`
     - `FirebreakJBKawaii/Scripts/.gitkeep`
     - `FirebreakJBKawaii/Supporting/.gitkeep`
   - Потом на каждый настоящий файл жми **Add file → Upload files** и
     перетаскивай его из распакованной папки

### Способ B: через git в терминале (быстрее, если знаешь git)

```bash
# 1. Распакуй архив
unzip FirebreakJBKawaii_source.zip
cd FirebreakJBKawaii

# 2. Инициализируй git и привяжи к GitHub
git init
git remote add origin https://github.com/ТВОЙ_ЛОГИН/FirebreakJBKawaii.git
git branch -M main

# 3. Залей всё
git add .
git commit -m "Initial commit — Firebreak source"
git push -u origin main
```

При пуше попросит логин+пароль. Используй **Personal Access Token** вместо
пароля: Settings → Developer settings → Personal access tokens → Tokens (classic) →
Generate new token → выбери `repo` scope → скопируй токен, вставь когда попросит.

---

## Шаг 4: Запуск сборки

Как только исходники в репо — workflow запустится **автоматически**.

1. Открой свой репозиторий на GitHub
2. Перейди на вкладку **Actions**
3. Слева в списке workflows выбери **Build IPA**
4. Открой последний запуск (жёлтый кружок → зелёная галочка)
5. Жди **~5 минут** — увидишь прогресс:
   ```
   Install XcodeGen ✓
   Generate Xcode project ✓
   Build .app (unsigned) ✓
   Package IPA ✓
   Upload IPA artifact ✓
   ```

Если сборка упала с ошибкой — открой лог, нажми на упавший step, посмотри
что не так. Скорее всего это какая-то мелочь в проекте.

---

## Шаг 5: Скачивание готового .ipa

1. В успешном запуске workflow прокрути вниз до секции **Artifacts**
2. Нажми на **FirebreakJBKawaii-ipa** — скачается `FirebreakJBKawaii-ipa.zip`
3. Распакуй его — внутри будет **`FirebreakJBKawaii.ipa`** (~1-3 MB)

Это твой рабочий .ipa, готовый к sideload.

---

## Шаг 6: Установка на iPhone через SideStore

1. Открой **SideStore** на айфоне
2. Нажми **Apps** → **+** (вверху справа)
3. Выбери скачанный `FirebreakJBKawaii.ipa`
4. Введи свой Apple ID и пароль (SideStore создаст бесплатный cert)
5. Жди ~30 секунд — приложение установится
6. На домашнем экране появится иконка **Firebreak** 🔥
7. При первом запуске: Настройки → Основные → VPN и управление устройством →
  信任 Apple ID, через который ставил (или Settings → General → VPN & Device Management → Trust)

**Cert действует 7 дней** на бесплатном Apple ID. После 7 дней открой SideStore,
найди Firebreak в списке → нажми **Refresh** → ещё на 7 дней.

---

## Бонус: автоматический релиз с тегами

Если хочешь, чтобы при создании тега `v3.0.1` автоматически создавался
GitHub Release с прикреплённым .ipa:

```bash
git tag v3.0.1
git push origin v3.0.1
```

GitHub Actions создаст Release на странице Releases — там .ipa будет лежать
постоянно (артефакты живут 90 дней, релизы — вечно).

---

## Что если сборка упала?

| Ошибка | Решение |
|--------|---------|
| `xcodegen: command not found` | Должно работать на GitHub — `brew install xcodegen` уже в workflow |
| `Swift Compiler Error` | Открой лог, посмотри в каком файле. Скорее всего опечатка |
| `Code Sign Error` | Не должно быть — workflow собирает unsigned. Если есть — проверь, что `project.yml` не изменён |
| `Firebreak.app not found` | xcodebuild упал до того как собрать .app. Смотри build.log |

В любом случае: открой лог упавшего step'а → там будет точная ошибка с
номером строки → пришли мне, исправим.

---

## Чек-лист перед заливкой

- ☑️ Архив `FirebreakJBKawaii_source.zip` распакован
- ☑️ Папка `Firebreak/` содержит `.github/workflows/build-ipa.yml`
- ☑️ Папка `Firebreak/` содержит `project.yml`, `Scripts/build.sh`, `README.md`
- ☑️ Папка `Firebreak/Firebreak/` содержит все 15 `.swift` файлов
- ☑️ Папка `Firebreak/Firebreak/Assets.xcassets/AppIcon.appiconset/` содержит `icon-1024.png`
- ☑️ Репозиторий **public**, не private
- ☑️ Apple ID работает (можно залогиниться в SideStore)

После этого — Actions сам соберёт .ipa, качай и ставь.
