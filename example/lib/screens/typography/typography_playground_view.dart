// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../shared/shared.dart';
import 'controls/typography_preview_controls.dart';
import 'controls/typography_variable_axes_controls.dart';
import 'models/typography_models.dart';
import 'preview/typography_preview_area.dart';
import 'snippets/typography_code_snippets.dart';

export 'models/typography_models.dart';

class TypographyPlaygroundView extends StatefulWidget {
  const TypographyPlaygroundView({super.key});

  @override
  State<TypographyPlaygroundView> createState() =>
      _TypographyPlaygroundViewState();
}

class _TypographyPlaygroundViewState extends State<TypographyPlaygroundView> {
  TypographyPreviewMode _previewMode = TypographyPreviewMode.customText;
  TypographyFont _font = TypographyFont.googleSansFlex;
  String _selectedPreset = 'Headline Medium';
  bool _isEmphasized = true;
  bool _applyBodyRond = false;
  final TextEditingController _textController = TextEditingController(
    text: 'Material 3 Expressive Typography',
  );

  double _wght = 600.0;
  double _wdth = 100.0;
  double _opsz = 32.0;
  double _rond = 0.0;
  double _slnt = 0.0;
  double _grad = 0.0;
  double _ytas = 750.0;
  double _ytde = -203.0;
  double _ytfi = 738.0;
  double _ytlc = 514.0;
  double _ytuc = 712.0;
  double _fontSize = 28.0;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _applyPreset(String preset, bool emphasized) {
    setState(() {
      _selectedPreset = preset;
      _isEmphasized = emphasized;
      switch (preset) {
        case 'Display Large':
          _fontSize = emphasized ? 64.0 : 57.0;
          _wght = emphasized ? 700.0 : 400.0;
          _opsz = _fontSize;
        case 'Headline Medium':
          _fontSize = emphasized ? 32.0 : 28.0;
          _wght = emphasized ? 600.0 : 400.0;
          _opsz = _fontSize;
        case 'Title Medium':
          _fontSize = emphasized ? 18.0 : 16.0;
          _wght = 500.0;
          _opsz = _fontSize;
        case 'Body Large':
          _fontSize = 16.0;
          _wght = 400.0;
          _opsz = 16.0;
        case 'Label Large':
          _fontSize = 14.0;
          _wght = emphasized ? 700.0 : 500.0;
          _opsz = 14.0;
      }
    });
  }

  String _generateCodeSnippet() {
    return TypographyCodeSnippets.generate(
      previewMode: _previewMode,
      font: _font,
      isEmphasized: _isEmphasized,
      rond: _rond,
      applyBodyRond: _applyBodyRond,
      fontSize: _fontSize,
      wght: _wght,
      wdth: _wdth,
      opsz: _opsz,
      slnt: _slnt,
      grad: _grad,
      ytas: _ytas,
      ytde: _ytde,
      ytfi: _ytfi,
      ytlc: _ytlc,
      ytuc: _ytuc,
    );
  }

  List<Widget> _buildControls() => [
    TypographyPreviewControls(
      previewMode: _previewMode,
      onPreviewModeChanged: (val) => setState(() => _previewMode = val),
      font: _font,
      onFontChanged: (val) => setState(() => _font = val),
      selectedPreset: _selectedPreset,
      onPresetSelected: (val) => _applyPreset(val, _isEmphasized),
      isEmphasized: _isEmphasized,
      onIsEmphasizedChanged: (val) => setState(() => _isEmphasized = val),
      rond: _rond,
      onRondChanged: (val) => setState(() => _rond = val),
      applyBodyRond: _applyBodyRond,
      onApplyBodyRondChanged: (val) => setState(() => _applyBodyRond = val),
    ),
    TypographyVariableAxesControls(
      font: _font,
      fontSize: _fontSize,
      onFontSizeChanged: (val) => setState(() => _fontSize = val),
      wght: _wght,
      onWghtChanged: (val) => setState(() => _wght = val),
      opsz: _opsz,
      onOpszChanged: (val) => setState(() => _opsz = val),
      rond: _rond,
      onRondChanged: (val) => setState(() => _rond = val),
      wdth: _wdth,
      onWdthChanged: (val) => setState(() => _wdth = val),
      slnt: _slnt,
      onSlntChanged: (val) => setState(() => _slnt = val),
      grad: _grad,
      onGradChanged: (val) => setState(() => _grad = val),
      ytas: _ytas,
      onYtasChanged: (val) => setState(() => _ytas = val),
      ytde: _ytde,
      onYtdeChanged: (val) => setState(() => _ytde = val),
      ytfi: _ytfi,
      onYtfiChanged: (val) => setState(() => _ytfi = val),
      ytlc: _ytlc,
      onYtlcChanged: (val) => setState(() => _ytlc = val),
      ytuc: _ytuc,
      onYtucChanged: (val) => setState(() => _ytuc = val),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PlaygroundSplitLayout(
      preview: TypographyPreviewArea(
        previewMode: _previewMode,
        font: _font,
        fontSize: _fontSize,
        wght: _wght,
        wdth: _wdth,
        opsz: _opsz,
        rond: _rond,
        slnt: _slnt,
        grad: _grad,
        ytas: _ytas,
        ytde: _ytde,
        ytfi: _ytfi,
        ytlc: _ytlc,
        ytuc: _ytuc,
        textController: _textController,
        isEmphasized: _isEmphasized,
        applyBodyRond: _applyBodyRond,
        onTextChanged: () => setState(() {}),
      ),
      codeSnippet: CodeSnippetCard(code: _generateCodeSnippet()),
      previewTitle: _previewMode == TypographyPreviewMode.customText
          ? 'Variable Font Preview'
          : 'Material 3 Expressive Type Scale',
      previewSubtitle: _previewMode == TypographyPreviewMode.customText
          ? 'Adjust ${_font.label} axes and inspect the generated TextStyle.'
          : 'Compare the active Material 3 type scale at a glance.',
      controls: _buildControls(),
    );
  }
}
