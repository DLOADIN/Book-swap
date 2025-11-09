import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/book_provider.dart';
import '../models/book.dart';
import '../widgets/modern_book_card.dart';
import '../widgets/stats_card.dart';
import '../widgets/quick_action_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = Provider.of<AuthProvider>(context);
    final bookProvider = Provider.of<BookProvider>(context);
    
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            // Custom App Bar with Gradient
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: theme.colorScheme.primary,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.secondary,
                        theme.colorScheme.tertiary,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white.withValues(alpha: 0.2),
                                child: Icon(
                                  Icons.eco_rounded,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome back,',
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.9),
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      auth.user?.displayName ?? 'Book Lover',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Notifications
                                },
                                icon: const Icon(
                                  Icons.notifications_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Main Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Row using StreamBuilder
                    StreamBuilder<List<Book>>(
                      stream: bookProvider.myBooks(auth.user?.uid ?? ''),
                      builder: (context, snapshot) {
                        final myBooksCount = snapshot.hasData ? snapshot.data!.length : 0;
                        
                        return Row(
                          children: [
                            Expanded(
                              child: StatsCard(
                                title: 'My Books',
                                value: '$myBooksCount',
                                icon: Icons.library_books_rounded,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: StatsCard(
                                title: 'Swaps Made',
                                value: '12', // This would come from a service
                                icon: Icons.swap_horiz_rounded,
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Quick Actions
                    Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: QuickActionCard(
                            title: 'Add Book',
                            subtitle: 'Share your books',
                            icon: Icons.add_circle_outline_rounded,
                            color: theme.colorScheme.tertiary,
                            onTap: () => Navigator.pushNamed(context, '/add-book'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: QuickActionCard(
                            title: 'Find Books',
                            subtitle: 'Discover new reads',
                            icon: Icons.search_rounded,
                            color: theme.colorScheme.secondary,
                            onTap: () {
                              // Switch to explore tab
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Recent Activity
                    Text(
                      'Your Recent Books',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            
            // Recent Books List using StreamBuilder
            StreamBuilder<List<Book>>(
              stream: bookProvider.myBooks(auth.user?.uid ?? ''),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                
                final books = snapshot.data!;
                
                if (books.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: theme.colorScheme.outline.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.menu_book_outlined,
                            size: 64,
                            color: theme.colorScheme.primary.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No books yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add your first book to get started!',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final book = books[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: ModernBookCard(
                          book: book,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/book-detail',
                              arguments: book,
                            );
                          },
                        ),
                      );
                    },
                    childCount: books.length > 3 ? 3 : books.length,
                  ),
                );
              },
            ),
            
            // View All Button
            StreamBuilder<List<Book>>(
              stream: bookProvider.myBooks(auth.user?.uid ?? ''),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.length <= 3) {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }
                
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to My Library screen
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: theme.colorScheme.primary,
                        elevation: 0,
                        side: BorderSide(color: theme.colorScheme.primary),
                      ),
                      child: const Text('View All My Books'),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}