import 'package:flutter/material.dart' hide ThemeExtension;

import 'theme.dart';

class ComponentShowcaseScreen extends StatefulWidget {
  const ComponentShowcaseScreen({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.selectedFont,
    required this.onFontChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final AppFont selectedFont;
  final ValueChanged<AppFont> onFontChanged;

  @override
  State<ComponentShowcaseScreen> createState() => _ComponentShowcaseScreenState();
}

class _ComponentShowcaseScreenState extends State<ComponentShowcaseScreen> with SingleTickerProviderStateMixin {
  // Interactive State
  Set<int> _segmentedSelection = {0};
  Set<int> _multiSegmentedSelection = {0, 2};
  bool? _checkboxValue = true;
  bool? _indeterminateCheckboxValue;
  int _radioGroupValue = 1;
  bool _switchValue = true;
  double _sliderValue = 0.6;
  double _discreteSliderValue = 40.0;
  RangeValues _rangeValues = const RangeValues(20.0, 70.0);

  bool _filterChipSelected = false;
  int _choiceChipSelected = 0;
  bool _showInputChip = true;

  final TextEditingController _textController = TextEditingController(text: 'Exemplo de texto');
  final TextEditingController _passwordController = TextEditingController(text: 'minhasenha123');
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  String? _selectedDropdown = 'Opção 1';

  late TabController _tabController;
  int _navigationBarIndex = 0;
  int _navigationRailIndex = 0;
  String _activeCategoryFilter = 'Todos';

  final List<String> _categories = [
    'Todos',
    'Cores & Tema',
    'Tipografia',
    'Botões',
    'Seleção',
    'Inputs & Forms',
    'Chips',
    'Cards',
    'Listas',
    'Progresso',
    'Feedback & Dialogs',
    'Navegação',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _textController.dispose();
    _passwordController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  bool _shouldShow(String category) {
    if (_activeCategoryFilter == 'Todos') return true;
    return _activeCategoryFilter == category;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = theme.extension<ThemeExtension>();

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Catálogo de Componentes'),
            Text('Material 3 & AppTheme', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
          ],
        ),
        actions: [
          PopupMenuButton<ThemeMode>(
            icon: Icon(
              widget.themeMode == ThemeMode.light
                  ? Icons.light_mode
                  : widget.themeMode == ThemeMode.dark
                  ? Icons.dark_mode
                  : Icons.brightness_auto,
            ),
            tooltip: 'Alterar Modo de Tema',
            initialValue: widget.themeMode,
            onSelected: widget.onThemeModeChanged,
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: ThemeMode.system,
                child: Row(children: [Icon(Icons.brightness_auto, size: 20), SizedBox(width: 8), Text('Sistema')]),
              ),
              PopupMenuItem(
                value: ThemeMode.light,
                child: Row(children: [Icon(Icons.light_mode, size: 20), SizedBox(width: 8), Text('Claro')]),
              ),
              PopupMenuItem(
                value: ThemeMode.dark,
                child: Row(children: [Icon(Icons.dark_mode, size: 20), SizedBox(width: 8), Text('Escuro')]),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Header configuration bar
          _buildConfigurationHeader(theme),
          const Divider(height: 1),

          // Main Scrollable Showcase Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_shouldShow('Cores & Tema')) _buildThemeColorsSection(theme, customTheme),
                if (_shouldShow('Tipografia')) _buildTypographySection(theme),
                if (_shouldShow('Botões')) _buildButtonsSection(theme),
                if (_shouldShow('Seleção')) _buildSelectionSection(theme),
                if (_shouldShow('Inputs & Forms')) _buildInputsSection(theme),
                if (_shouldShow('Chips')) _buildChipsSection(theme),
                if (_shouldShow('Cards')) _buildCardsSection(theme, customTheme),
                if (_shouldShow('Listas')) _buildListsSection(theme),
                if (_shouldShow('Progresso')) _buildProgressSection(theme),
                if (_shouldShow('Feedback & Dialogs')) _buildFeedbackSection(theme, context),
                if (_shouldShow('Navegação')) _buildNavigationSection(theme),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _shouldShow('Navegação') || _activeCategoryFilter == 'Todos'
          ? NavigationBar(
              selectedIndex: _navigationBarIndex,
              onDestinationSelected: (int index) {
                setState(() => _navigationBarIndex = index);
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: 'Início',
                ),
                NavigationDestination(
                  icon: Icon(Icons.widgets_outlined),
                  selectedIcon: Icon(Icons.widgets),
                  label: 'Componentes',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: 'Ajustes',
                ),
              ],
            )
          : null,
    );
  }

  Widget _buildConfigurationHeader(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceContainerLow,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.font_download, size: 20),
              // const SizedBox(width: 8),
              // Text('Fonte Ativa:', style: theme.textTheme.labelLarge),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<AppFont>(
                    value: widget.selectedFont,
                    isDense: true,
                    isExpanded: true,
                    onChanged: (AppFont? newFont) {
                      if (newFont != null) {
                        widget.onFontChanged(newFont);
                      }
                    },
                    items: AppFont.values.map((AppFont font) {
                      return DropdownMenuItem<AppFont>(
                        value: font,
                        child: Text(font.label, style: TextStyle(fontFamily: font.label)),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode, size: 16)),
                  ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.brightness_auto, size: 16)),
                  ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode, size: 16)),
                ],
                selected: {widget.themeMode},
                onSelectionChanged: (Set<ThemeMode> selection) {
                  widget.onThemeModeChanged(selection.first);
                },
                style: const ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Horizontal Category Pills
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _activeCategoryFilter == category;
                return ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _activeCategoryFilter = category);
                    }
                  },
                  visualDensity: VisualDensity.compact,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required ThemeData theme,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: 10),
                Text(title, style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary)),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  // --- SECTION 1: CORES DO TEMA & EXTENSÕES ---
  Widget _buildThemeColorsSection(ThemeData theme, ThemeExtension? customTheme) {
    return _buildSectionCard(
      theme: theme,
      title: 'Cores do Tema & ThemeExtension',
      icon: Icons.palette_outlined,
      children: [
        Text('Paleta de Cores do ColorScheme:', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildColorTile('Primary', theme.colorScheme.primary, theme.colorScheme.onPrimary),
            _buildColorTile(
              'Primary Container',
              theme.colorScheme.primaryContainer,
              theme.colorScheme.onPrimaryContainer,
            ),
            _buildColorTile('Secondary', theme.colorScheme.secondary, theme.colorScheme.onSecondary),
            _buildColorTile(
              'Secondary Container',
              theme.colorScheme.secondaryContainer,
              theme.colorScheme.onSecondaryContainer,
            ),
            _buildColorTile('Tertiary', theme.colorScheme.tertiary, theme.colorScheme.onTertiary),
            _buildColorTile('Surface', theme.colorScheme.surface, theme.colorScheme.onSurface),
            _buildColorTile('Surface Container', theme.colorScheme.surfaceContainer, theme.colorScheme.onSurface),
            _buildColorTile('Outline', theme.colorScheme.outline, theme.colorScheme.surface),
            _buildColorTile('Error', theme.colorScheme.error, theme.colorScheme.onError),
          ],
        ),
        const SizedBox(height: 20),
        Text('Campos Personalizados do ThemeExtension:', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        if (customTheme != null)
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildColorTile('Border', customTheme.border, theme.colorScheme.onSurface),
              _buildColorTile('Surface Muted', customTheme.surfaceMuted, theme.colorScheme.onSurface),
              _buildColorTile('Success', customTheme.success, customTheme.onSuccess),
              _buildColorTile('Warning', customTheme.warning, customTheme.onWarning),
              _buildColorTile('Danger', customTheme.danger, customTheme.onDanger),
            ],
          ),
      ],
    );
  }

  Widget _buildColorTile(String name, Color color, Color textColor) {
    final hexString = color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase();
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text('#$hexString', style: TextStyle(color: textColor.withValues(alpha: 0.8), fontSize: 10)),
        ],
      ),
    );
  }

  // --- SECTION 2: TIPOGRAFIA ---
  Widget _buildTypographySection(ThemeData theme) {
    return _buildSectionCard(
      theme: theme,
      title: 'Tipografia (TextTheme)',
      icon: Icons.text_fields_outlined,
      children: [
        _buildTextStyleRow('Display Large', theme.textTheme.displayLarge),
        _buildTextStyleRow('Display Medium', theme.textTheme.displayMedium),
        _buildTextStyleRow('Display Small', theme.textTheme.displaySmall),
        _buildTextStyleRow('Headline Large', theme.textTheme.headlineLarge),
        _buildTextStyleRow('Headline Medium', theme.textTheme.headlineMedium),
        _buildTextStyleRow('Headline Small', theme.textTheme.headlineSmall),
        _buildTextStyleRow('Title Large', theme.textTheme.titleLarge),
        _buildTextStyleRow('Title Medium', theme.textTheme.titleMedium),
        _buildTextStyleRow('Title Small', theme.textTheme.titleSmall),
        _buildTextStyleRow('Body Large', theme.textTheme.bodyLarge),
        _buildTextStyleRow('Body Medium', theme.textTheme.bodyMedium),
        _buildTextStyleRow('Body Small', theme.textTheme.bodySmall),
        _buildTextStyleRow('Label Large', theme.textTheme.labelLarge),
        _buildTextStyleRow('Label Medium', theme.textTheme.labelMedium),
        _buildTextStyleRow('Label Small', theme.textTheme.labelSmall),
      ],
    );
  }

  Widget _buildTextStyleRow(String name, TextStyle? style) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$name (${style?.fontSize?.toInt()}pt, ${style?.fontWeight})',
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 2),
          Text('O rápido sapo marrom salta sobre o cão preguiçoso', style: style),
          const Divider(height: 12),
        ],
      ),
    );
  }

  // --- SECTION 3: BOTÕES ---
  Widget _buildButtonsSection(ThemeData theme) {
    return _buildSectionCard(
      theme: theme,
      title: 'Botões (Buttons & FAB)',
      icon: Icons.smart_button_outlined,
      children: [
        Text('ElevatedButton & FilledButton:', style: theme.textTheme.titleMedium),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
            ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.add), label: const Text('Elevated Icon')),
            const ElevatedButton(onPressed: null, child: Text('Desabilitado')),
            FilledButton(onPressed: () {}, child: const Text('Filled')),
            FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.check), label: const Text('Filled Icon')),
            FilledButton.tonal(onPressed: () {}, child: const Text('Filled Tonal')),
          ],
        ),
        const SizedBox(height: 20),
        Text('OutlinedButton & TextButton:', style: theme.textTheme.titleMedium),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
            OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.edit), label: const Text('Outlined Icon')),
            const OutlinedButton(onPressed: null, child: Text('Desabilitado')),
            TextButton(onPressed: () {}, child: const Text('Text Button')),
            TextButton.icon(onPressed: () {}, icon: const Icon(Icons.info), label: const Text('Text Icon')),
          ],
        ),
        const SizedBox(height: 20),
        Text('IconButton (Variantes):', style: theme.textTheme.titleMedium),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
            IconButton.filled(onPressed: () {}, icon: const Icon(Icons.favorite)),
            IconButton.filledTonal(onPressed: () {}, icon: const Icon(Icons.star)),
            IconButton.outlined(onPressed: () {}, icon: const Icon(Icons.share)),
          ],
        ),
        const SizedBox(height: 20),
        Text('FloatingActionButton & SegmentedButton:', style: theme.textTheme.titleMedium),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            FloatingActionButton.small(onPressed: () {}, child: const Icon(Icons.add)),
            FloatingActionButton(onPressed: () {}, child: const Icon(Icons.navigation)),
            FloatingActionButton.extended(onPressed: () {}, icon: const Icon(Icons.send), label: const Text('Enviar')),
          ],
        ),
        const SizedBox(height: 16),
        Text('SegmentedButton (Seleção Única):', style: theme.textTheme.bodySmall),
        const SizedBox(height: 6),
        SegmentedButton<int>(
          segments: const [
            ButtonSegment(value: 0, label: Text('Dia'), icon: Icon(Icons.wb_sunny)),
            ButtonSegment(value: 1, label: Text('Semana'), icon: Icon(Icons.calendar_view_week)),
            ButtonSegment(value: 2, label: Text('Mês'), icon: Icon(Icons.calendar_month)),
          ],
          selected: _segmentedSelection,
          onSelectionChanged: (Set<int> newSelection) {
            setState(() => _segmentedSelection = newSelection);
          },
        ),
        const SizedBox(height: 12),
        Text('SegmentedButton (Seleção Múltipla):', style: theme.textTheme.bodySmall),
        const SizedBox(height: 6),
        SegmentedButton<int>(
          multiSelectionEnabled: true,
          segments: const [
            ButtonSegment(value: 0, label: Text('Bold'), icon: Icon(Icons.format_bold)),
            ButtonSegment(value: 1, label: Text('Italic'), icon: Icon(Icons.format_italic)),
            ButtonSegment(value: 2, label: Text('Underline'), icon: Icon(Icons.format_underlined)),
          ],
          selected: _multiSegmentedSelection,
          onSelectionChanged: (Set<int> newSelection) {
            setState(() => _multiSegmentedSelection = newSelection);
          },
        ),
      ],
    );
  }

  // --- SECTION 4: SELEÇÃO & CONTROLES ---
  Widget _buildSelectionSection(ThemeData theme) {
    return _buildSectionCard(
      theme: theme,
      title: 'Seleção & Controles (Toggles, Sliders)',
      icon: Icons.check_box_outlined,
      children: [
        Text('Checkboxes & Radios:', style: theme.textTheme.titleMedium),
        Row(
          children: [
            Checkbox(value: _checkboxValue, onChanged: (val) => setState(() => _checkboxValue = val)),
            const Text('Marcado'),
            const SizedBox(width: 16),
            Checkbox(value: false, onChanged: (val) {}),
            const Text('Desmarcado'),
            const SizedBox(width: 16),
            Checkbox(
              value: _indeterminateCheckboxValue,
              tristate: true,
              onChanged: (val) => setState(() => _indeterminateCheckboxValue = val),
            ),
            const Text('Indeterminado'),
          ],
        ),
        RadioGroup<int>(
          groupValue: _radioGroupValue,
          onChanged: (val) {
            if (val != null) setState(() => _radioGroupValue = val);
          },
          child: const Row(
            children: [
              Row(children: [Radio<int>(value: 1), Text('Opção 1')]),
              SizedBox(width: 16),
              Row(children: [Radio<int>(value: 2), Text('Opção 2')]),
              SizedBox(width: 16),
              Row(children: [Radio<int>(value: 3), Text('Opção 3')]),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text('Switches e ListTiles com Controle:', style: theme.textTheme.titleMedium),
        Row(
          children: [
            Switch(value: _switchValue, onChanged: (val) => setState(() => _switchValue = val)),
            const SizedBox(width: 8),
            Text(_switchValue ? 'Ativado' : 'Desativado'),
            const SizedBox(width: 24),
            const Switch(value: false, onChanged: null),
            const SizedBox(width: 8),
            const Text('Desabilitado'),
          ],
        ),
        SwitchListTile(
          title: const Text('Notificações de Alerta'),
          subtitle: const Text('Receber alertas em tempo real no dispositivo'),
          value: _switchValue,
          onChanged: (val) => setState(() => _switchValue = val),
        ),
        CheckboxListTile(
          title: const Text('Aceitar termos de uso'),
          subtitle: const Text('Declaro que li e concordo com os termos'),
          value: _checkboxValue ?? false,
          onChanged: (val) => setState(() => _checkboxValue = val),
        ),
        const SizedBox(height: 16),
        Text('Sliders:', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Text('Contínuo: ${(_sliderValue * 100).toInt()}%'),
        Slider(value: _sliderValue, onChanged: (val) => setState(() => _sliderValue = val)),
        Text('Discreto (Passos): ${_discreteSliderValue.toInt()}'),
        Slider(
          value: _discreteSliderValue,
          min: 0,
          max: 100,
          divisions: 5,
          label: _discreteSliderValue.round().toString(),
          onChanged: (val) => setState(() => _discreteSliderValue = val),
        ),
        Text('Intervalo (Range): ${_rangeValues.start.round()} - ${_rangeValues.end.round()}'),
        RangeSlider(
          values: _rangeValues,
          min: 0,
          max: 100,
          divisions: 10,
          labels: RangeLabels(_rangeValues.start.round().toString(), _rangeValues.end.round().toString()),
          onChanged: (values) => setState(() => _rangeValues = values),
        ),
      ],
    );
  }

  // --- SECTION 5: INPUTS & FORMS ---
  Widget _buildInputsSection(ThemeData theme) {
    return _buildSectionCard(
      theme: theme,
      title: 'Campos de Entrada & Formulários',
      icon: Icons.edit_note_outlined,
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Nome de Usuário',
                  hintText: 'Digite seu nome de usuário',
                  prefixIcon: Icon(Icons.person_outline),
                  helperText: 'Nome exibido no perfil público',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Campo com Erro',
                  errorText: 'Formato de e-mail inválido',
                  prefixIcon: Icon(Icons.error_outline),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedDropdown,
                decoration: const InputDecoration(labelText: 'Selecione uma opção', prefixIcon: Icon(Icons.list_alt)),
                items: ['Opção 1', 'Opção 2', 'Opção 3'].map((String val) {
                  return DropdownMenuItem<String>(value: val, child: Text(val));
                }).toList(),
                onChanged: (val) => setState(() => _selectedDropdown = val),
              ),
              const SizedBox(height: 16),
              SearchBar(
                hintText: 'Buscar componentes...',
                leading: const Icon(Icons.search),
                padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- SECTION 6: CHIPS ---
  Widget _buildChipsSection(ThemeData theme) {
    return _buildSectionCard(
      theme: theme,
      title: 'Chips (Filter, Choice, Action, Input)',
      icon: Icons.label_outlined,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            FilterChip(
              label: const Text('FilterChip'),
              selected: _filterChipSelected,
              onSelected: (selected) => setState(() => _filterChipSelected = selected),
            ),
            ActionChip(
              avatar: const Icon(Icons.event, size: 18),
              label: const Text('ActionChip (Adicionar evento)'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ActionChip pressionado!')));
              },
            ),
            if (_showInputChip)
              InputChip(
                avatar: const CircleAvatar(child: Text('M')),
                label: const Text('InputChip (Tag)'),
                onDeleted: () => setState(() => _showInputChip = false),
              ),
            if (!_showInputChip)
              TextButton.icon(
                onPressed: () => setState(() => _showInputChip = true),
                icon: const Icon(Icons.refresh),
                label: const Text('Restaurar InputChip'),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text('ChoiceChips:', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: List<Widget>.generate(3, (int index) {
            return ChoiceChip(
              label: Text('Escolha ${index + 1}'),
              selected: _choiceChipSelected == index,
              onSelected: (bool selected) {
                if (selected) {
                  setState(() => _choiceChipSelected = index);
                }
              },
            );
          }),
        ),
      ],
    );
  }

  // --- SECTION 7: CARDS & CONTAINERS ---
  Widget _buildCardsSection(ThemeData theme, ThemeExtension? customTheme) {
    return _buildSectionCard(
      theme: theme,
      title: 'Cards & Contêineres Personalizados',
      icon: Icons.credit_card_outlined,
      children: [
        Row(
          children: [
            Expanded(
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(height: 8),
                      Text('Elevated Card', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text('Sombra suave', style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Card(
                color: theme.colorScheme.surfaceContainerHighest,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.layers_outlined, color: theme.colorScheme.primary),
                      const SizedBox(height: 8),
                      Text('Filled Card', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text('Fundo preenchido', style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: theme.colorScheme.outline),
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.border_style, size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Outlined Card', style: theme.textTheme.titleMedium),
                      Text('Contorno visível de acordo com o outline do tema', style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (customTheme != null) ...[
          Text('Cards com Cores do ThemeExtension:', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: customTheme.success.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: customTheme.success),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.check_circle_outline, color: customTheme.success),
                      const SizedBox(height: 4),
                      Text(
                        'Sucesso',
                        style: TextStyle(color: customTheme.success, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: customTheme.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: customTheme.warning),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.warning_amber_outlined, color: customTheme.warning),
                      const SizedBox(height: 4),
                      Text(
                        'Aviso',
                        style: TextStyle(color: customTheme.warning, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: customTheme.danger.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: customTheme.danger),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, color: customTheme.danger),
                      const SizedBox(height: 4),
                      Text(
                        'Perigo',
                        style: TextStyle(color: customTheme.danger, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  // --- SECTION 8: LISTAS & EXPANSÃO ---
  Widget _buildListsSection(ThemeData theme) {
    return _buildSectionCard(
      theme: theme,
      title: 'Listas, Divisores & Expansão',
      icon: Icons.list_alt_outlined,
      children: [
        ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: const Text('Item de Lista Padrão'),
          subtitle: const Text('Com avatar, título e ação à direita'),
          trailing: IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.star),
          title: const Text('Item com Seleção'),
          subtitle: const Text('Estilizado pelo ListTileThemeData'),
          trailing: Badge.count(count: 3, child: const Icon(Icons.mail_outline)),
        ),
        const SizedBox(height: 8),
        ExpansionTile(
          leading: const Icon(Icons.folder_open),
          title: const Text('Grupo Expansível (ExpansionTile)'),
          subtitle: const Text('Clique para expandir o conteúdo'),
          children: [
            ListTile(leading: const Icon(Icons.insert_drive_file), title: const Text('Subitem 1'), onTap: () {}),
            ListTile(leading: const Icon(Icons.insert_drive_file), title: const Text('Subitem 2'), onTap: () {}),
          ],
        ),
      ],
    );
  }

  // --- SECTION 9: PROGRESSO & BADGES ---
  Widget _buildProgressSection(ThemeData theme) {
    return _buildSectionCard(
      theme: theme,
      title: 'Indicadores de Progresso & Badges',
      icon: Icons.hourglass_top_outlined,
      children: [
        Text('CircularProgressIndicator:', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        const Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 24),
            CircularProgressIndicator(value: 0.75),
            SizedBox(width: 8),
            Text('75%'),
          ],
        ),
        const SizedBox(height: 20),
        Text('LinearProgressIndicator:', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        const LinearProgressIndicator(),
        const SizedBox(height: 12),
        const LinearProgressIndicator(value: 0.4),
        const SizedBox(height: 20),
        Text('Badges:', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Badge(child: const Icon(Icons.notifications, size: 32)),
            Badge.count(count: 9, child: const Icon(Icons.shopping_cart, size: 32)),
            Badge.count(count: 99, child: const Icon(Icons.chat_bubble, size: 32)),
          ],
        ),
      ],
    );
  }

  // --- SECTION 10: FEEDBACK & DIALOGS ---
  Widget _buildFeedbackSection(ThemeData theme, BuildContext context) {
    return _buildSectionCard(
      theme: theme,
      title: 'Diálogos, Sheets & Feedback',
      icon: Icons.feedback_outlined,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.chat),
              label: const Text('AlertDialog'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Exemplo de AlertDialog'),
                    content: const Text(
                      'Este é um diálogo de alerta personalizado pelo DialogThemeData do theme.dart.',
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                      FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Confirmar')),
                    ],
                  ),
                );
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.vertical_align_bottom),
              label: const Text('BottomSheet'),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Modal Bottom Sheet', style: theme.textTheme.headlineSmall),
                        const SizedBox(height: 12),
                        const Text('Estilizado de acordo com bottomSheetTheme (cantos arredondados, alça de arraste).'),
                        const SizedBox(height: 20),
                        FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar')),
                      ],
                    ),
                  ),
                );
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.date_range),
              label: const Text('DatePicker'),
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.access_time),
              label: const Text('TimePicker'),
              onPressed: () {
                showTimePicker(context: context, initialTime: TimeOfDay.now());
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.dns),
              label: const Text('Exibir SnackBar'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Esta é uma notificação SnackBar flutuante!'),
                    action: SnackBarAction(label: 'DESFAZER', onPressed: () {}),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text('Exemplo de Tooltip: '),
            Tooltip(
              message: 'Este é um tooltip estilizado',
              child: ElevatedButton(onPressed: () {}, child: const Text('Passe o mouse / Pressione e segure')),
            ),
          ],
        ),
      ],
    );
  }

  // --- SECTION 11: NAVEGAÇÃO & ABAS ---
  Widget _buildNavigationSection(ThemeData theme) {
    return _buildSectionCard(
      theme: theme,
      title: 'Componentes de Navegação & Abas',
      icon: Icons.explore_outlined,
      children: [
        Text('TabBar & TabBarView:', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.phone), text: 'Chamadas'),
                  Tab(icon: Icon(Icons.chat), text: 'Conversas'),
                  Tab(icon: Icon(Icons.contacts), text: 'Contatos'),
                ],
              ),
              SizedBox(
                height: 100,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Center(child: Text('Aba Chamadas', style: theme.textTheme.bodyLarge)),
                    Center(child: Text('Aba Conversas', style: theme.textTheme.bodyLarge)),
                    Center(child: Text('Aba Contatos', style: theme.textTheme.bodyLarge)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text('NavigationRail Preview:', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Container(
          height: 180,
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              NavigationRail(
                selectedIndex: _navigationRailIndex,
                onDestinationSelected: (int index) {
                  setState(() => _navigationRailIndex = index);
                },
                labelType: NavigationRailLabelType.selected,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite_border),
                    selectedIcon: Icon(Icons.favorite),
                    label: Text('Favoritos'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.bookmark_border),
                    selectedIcon: Icon(Icons.bookmark),
                    label: Text('Salvos'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.star_border),
                    selectedIcon: Icon(Icons.star),
                    label: Text('Destaques'),
                  ),
                ],
              ),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(child: Center(child: Text('Conteúdo do painel $_navigationRailIndex'))),
            ],
          ),
        ),
      ],
    );
  }
}
