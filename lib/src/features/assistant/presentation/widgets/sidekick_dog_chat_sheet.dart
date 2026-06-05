import 'package:flutter/material.dart';

import 'package:aura_pet/src/core/models/assistant_request.dart';
import 'package:aura_pet/src/core/models/assistant_response.dart';
import 'package:aura_pet/src/core/routes/services/assistant_service.dart';
import 'package:aura_pet/src/widgets/app_background.dart';

enum _ChatMessageKind { user, assistant, loading, error }

class _ChatMessage {
  final _ChatMessageKind kind;
  final String text;
  final String? disclaimer;
  final bool recommendVet;
  final List<String> suggestedFollowups;
  final String? retryText;

  const _ChatMessage({
    required this.kind,
    required this.text,
    this.disclaimer,
    this.recommendVet = false,
    this.suggestedFollowups = const [],
    this.retryText,
  });

  bool get isUser => kind == _ChatMessageKind.user;
  bool get isLoading => kind == _ChatMessageKind.loading;
  bool get isError => kind == _ChatMessageKind.error;
}

class SidekickDogChatSheet extends StatefulWidget {
  const SidekickDogChatSheet({super.key, AssistantService? assistantService})
    : _assistantService = assistantService;

  final AssistantService? _assistantService;

  @override
  State<SidekickDogChatSheet> createState() => _SidekickDogChatSheetState();
}

class _SidekickDogChatSheetState extends State<SidekickDogChatSheet> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final AssistantService _assistantService;

  final List<_ChatMessage> _messages = const [
    _ChatMessage(
      kind: _ChatMessageKind.assistant,
      text:
          'Hola, soy sidekickDog. Preguntame sobre razas, cuidados o senales de alerta.',
    ),
  ].toList();

  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _assistantService = widget._assistantService ?? AssistantService();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool afterLayoutSettles = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animateToBottom();
    });

    if (!afterLayoutSettles) return;
    Future<void>.delayed(const Duration(milliseconds: 90), () {
      if (!mounted) return;
      _animateToBottom();
    });
  }

  void _animateToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  Future<void> _sendCurrentMessage() async {
    await _sendMessage(_messageController.text);
  }

  Future<void> _sendMessage(String rawText) async {
    final text = rawText.trim();
    if (text.isEmpty || _sending) return;

    setState(() {
      _sending = true;
      _messages.add(_ChatMessage(kind: _ChatMessageKind.user, text: text));
      _messages.add(
        const _ChatMessage(
          kind: _ChatMessageKind.loading,
          text: 'sidekickDog esta pensando...',
        ),
      );
      _messageController.clear();
    });
    _scrollToBottom();

    try {
      final response = await _assistantService.sendMessage(
        AssistantRequest(
          message: text,
          language: 'es',
          includeDisclaimer: true,
          // Preparado para enviar intent, breed y dogContext cuando la UI
          // tenga una raza o contexto de perro seleccionado.
        ),
      );

      if (!mounted) return;
      setState(() {
        _sending = false;
        _replaceLoadingMessage(_messageFromResponse(response));
      });
      _scrollToBottom(afterLayoutSettles: true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _sending = false;
        _replaceLoadingMessage(
          _ChatMessage(
            kind: _ChatMessageKind.error,
            text: _friendlyError(e),
            retryText: text,
          ),
        );
      });
      _scrollToBottom(afterLayoutSettles: true);
    }
  }

  void _replaceLoadingMessage(_ChatMessage message) {
    final index = _messages.lastIndexWhere((item) => item.isLoading);
    if (index == -1) {
      _messages.add(message);
      return;
    }
    _messages[index] = message;
  }

  _ChatMessage _messageFromResponse(AssistantResponse response) {
    return _ChatMessage(
      kind: _ChatMessageKind.assistant,
      text: response.answer.isEmpty
          ? 'No recibi una respuesta clara. Intenta preguntarlo de otra forma.'
          : response.answer,
      disclaimer: response.disclaimer,
      recommendVet: response.recommendVet,
      suggestedFollowups: response.suggestedFollowups,
    );
  }

  String _friendlyError(Object error) {
    final text = error.toString().replaceFirst('Exception: ', '').trim();
    if (text.isEmpty) {
      return 'No pude conectar con Aura Assistant. Intentalo de nuevo.';
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final height = MediaQuery.sizeOf(context).height;
    final sheetMaxHeight = height * 0.88;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      constraints: BoxConstraints(maxHeight: sheetMaxHeight),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: AppBackground(
          opacity: 0.06,
          alignment: Alignment.topLeft,
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ChatHeader(theme: textTheme),
                const Divider(height: 1),
                Flexible(
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    itemCount: _messages.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _MessageBubble(
                        message: message,
                        onRetry: message.retryText == null
                            ? null
                            : () => _sendMessage(message.retryText!),
                      );
                    },
                  ),
                ),
                _ChatInput(
                  controller: _messageController,
                  sending: _sending,
                  onSend: _sendCurrentMessage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  final TextTheme theme;

  const _ChatHeader({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 8),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFD7F0FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF89CFF0).withValues(alpha: 0.7),
              ),
            ),
            child: const Icon(Icons.pets_rounded, color: Color(0xFF1F7BCB)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'sidekickDog',
                  style: theme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Aura Assistant',
                  style: theme.bodySmall?.copyWith(
                    color: const Color(0xFF4E6F86),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded),
            color: const Color(0xFF4E6F86),
            tooltip: 'Cerrar',
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;
  final VoidCallback? onRetry;

  const _MessageBubble({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bubbleColor = message.isUser
        ? const Color(0xFFD8ECFF)
        : message.isError
        ? const Color(0xFFFFF3E0)
        : const Color(0xFFF1F6FB);
    final borderColor = message.isUser
        ? const Color(0xFF8AC8F0)
        : message.isError
        ? const Color(0xFFFFB86B)
        : const Color(0xFFD1DCE6);

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 330),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: message.isLoading
              ? const _LoadingMessage()
              : _MessageContent(
                  message: message,
                  theme: textTheme,
                  onRetry: onRetry,
                ),
        ),
      ),
    );
  }
}

class _LoadingMessage extends StatelessWidget {
  const _LoadingMessage();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 16,
          width: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        SizedBox(width: 10),
        Flexible(child: Text('Consultando Aura Assistant...')),
      ],
    );
  }
}

class _MessageContent extends StatelessWidget {
  final _ChatMessage message;
  final TextTheme theme;
  final VoidCallback? onRetry;

  const _MessageContent({
    required this.message,
    required this.theme,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message.text,
          style: theme.bodyMedium?.copyWith(
            color: const Color(0xFF17324D),
            height: 1.35,
          ),
        ),
        if (message.recommendVet) ...[
          const SizedBox(height: 10),
          const _VetNotice(),
        ],
        if (message.disclaimer != null) ...[
          const SizedBox(height: 10),
          _Disclaimer(text: message.disclaimer!),
        ],
        if (message.suggestedFollowups.isNotEmpty) ...[
          const SizedBox(height: 10),
          _SuggestedFollowups(followups: message.suggestedFollowups),
        ],
        if (onRetry != null) ...[
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Reintentar'),
          ),
        ],
      ],
    );
  }
}

class _VetNotice extends StatelessWidget {
  const _VetNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE4D6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFF9F80)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.medical_services_outlined, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text('Por seguridad, conviene consultar a un veterinario.'),
          ),
        ],
      ),
    );
  }
}

class _SuggestedFollowups extends StatelessWidget {
  final List<String> followups;

  const _SuggestedFollowups({required this.followups});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Para orientarte mejor, dime:',
          style: textTheme.bodySmall?.copyWith(
            color: const Color(0xFF5F6D78),
            fontWeight: FontWeight.w600,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 6),
        ...followups.map(
          (followup) => Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '•',
                  style: textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF5F6D78),
                    height: 1.3,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    followup,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF17324D),
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Disclaimer extends StatelessWidget {
  final String text;

  const _Disclaimer({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: const Color(0xFF5F6D78),
        height: 1.3,
      ),
    );
  }
}

class _ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final bool sending;
  final VoidCallback onSend;

  const _ChatInput({
    required this.controller,
    required this.sending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FBFF),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF91C5E8), width: 1.1),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                enabled: !sending,
                decoration: const InputDecoration(
                  hintText: 'Escribe un mensaje...',
                  border: InputBorder.none,
                  isDense: true,
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: sending
                  ? const Color(0xFFB5DDF0)
                  : const Color(0xFF6ECFF8),
              shape: const CircleBorder(),
              child: IconButton(
                onPressed: sending ? null : onSend,
                icon: const Icon(Icons.send_rounded, color: Colors.white),
                tooltip: 'Enviar mensaje',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
