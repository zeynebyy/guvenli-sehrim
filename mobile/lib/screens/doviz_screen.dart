import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_keys.dart';
import '../core/constants/app_colors.dart';
import '../providers/doviz_provider.dart';
import '../widgets/common/loading_view.dart';
import '../widgets/common/error_view.dart';

class DovizScreen extends StatefulWidget {
  const DovizScreen({super.key});

  @override
  State<DovizScreen> createState() => _DovizScreenState();
}

class _DovizScreenState extends State<DovizScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DovizProvider>().fetchDoviz();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DovizProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Döviz Kurları', 
          style: GoogleFonts.outfit(fontWeight: FontWeight.w900, letterSpacing: 0.5)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark ? AppColors.dashDark : AppColors.dashLight,
          ),
        ),
        child: provider.isLoading
            ? const LoadingView()
            : provider.error != null
                ? ErrorView(message: provider.error!, onRetry: provider.fetchDoviz)
                : SafeArea(
                    child: Column(
                      children: [
                        _buildMarketStatus(isDark),
                        Expanded(child: _buildCurrencyList(provider.dovizList, isDark)),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildMarketStatus(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (isDark ? Colors.white : Colors.indigo).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.currency_exchange_rounded, 
                color: isDark ? Colors.white : Colors.indigo, size: 40),
          ),
          const SizedBox(height: 16),
          Text(
            'MERKEZ BANKASI',
            style: GoogleFonts.outfit(
              fontSize: 12, 
              fontWeight: FontWeight.w900, 
              letterSpacing: 2, 
              color: isDark ? Colors.white70 : Colors.indigo
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Güncel Piyasa Verileri',
            style: GoogleFonts.outfit(
              fontSize: 18, 
              color: isDark ? Colors.white54 : Colors.grey.shade600,
              fontWeight: FontWeight.w400
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyList(List list, bool isDark) {
    return ListView.builder(
      key: const Key(AppKeys.dovizList),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      itemCount: list.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final item = list[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: (isDark ? Colors.white : Colors.black).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: (isDark ? Colors.white : Colors.black).withOpacity(0.05)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.indigo.withOpacity(0.2)),
                      ),
                      child: Text(item.code, 
                        style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: Colors.indigo, fontSize: 13)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, 
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 16, color: isDark ? Colors.white : Colors.black87)),
                          Text('TCMB RESMİ KUR', 
                            style: GoogleFonts.outfit(fontSize: 10, color: isDark ? Colors.white54 : Colors.black38, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₺${item.buying}',
                          key: Key('${AppKeys.dovizKurPrefix}${item.code}'),
                          style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 18, color: isDark ? Colors.white : Colors.black87),
                        ),
                        Text('Satış: ₺${item.selling}', 
                          style: GoogleFonts.outfit(fontSize: 11, color: isDark ? Colors.white38 : Colors.grey, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
