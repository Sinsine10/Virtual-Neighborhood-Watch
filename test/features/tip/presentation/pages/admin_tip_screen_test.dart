import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:neihborhoodwatch/features/tip/data/services/api_service.dart';
import 'package:neihborhoodwatch/features/tip/domain/entities/tip.dart';
import 'package:neihborhoodwatch/features/tip/presentation/pages/Admin_Tip_screen.dart';
import 'package:neihborhoodwatch/features/tip/presentation/providers/tip_provider.dart';

@GenerateMocks([ApiService])
import 'admin_tip_screen_test.mocks.dart';

void main() {
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        tipProvider.overrideWith((ref) => TipNotifier(mockApiService)),
      ],
      child: const MaterialApp(
        home: AdminTipScreen(),
      ),
    );
  }

  group('AdminTipScreen Widget Tests', () {
    testWidgets('should show loading indicator when fetching tips',
        (WidgetTester tester) async {
      // arrange
      when(mockApiService.fetchTips()).thenAnswer(
        (_) => Future.delayed(const Duration(seconds: 1), () => []),
      );

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(); // Initial build

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display tips when data is loaded',
        (WidgetTester tester) async {
      // arrange
      final tips = [
        Tip(id: 1, description: 'Test Tip 1'),
        Tip(id: 2, description: 'Test Tip 2'),
      ];
      when(mockApiService.fetchTips()).thenAnswer((_) async => tips);

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(); // Wait for animations

      // assert
      expect(find.text('Test Tip 1'), findsOneWidget);
      expect(find.text('Test Tip 2'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should show error message when fetch fails',
        (WidgetTester tester) async {
      // arrange
      when(mockApiService.fetchTips())
          .thenThrow(Exception('Failed to fetch tips'));

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // assert
      expect(find.text('Exception: Failed to fetch tips'), findsOneWidget);
    });

    testWidgets('should show add tip dialog when FAB is pressed',
        (WidgetTester tester) async {
      // arrange
      when(mockApiService.fetchTips()).thenAnswer((_) async => []);
      when(mockApiService.addTip(any)).thenAnswer((_) async => null);

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // assert
      expect(find.text('Add Tip'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Post'), findsOneWidget);
    });

    testWidgets('should add new tip when dialog is submitted',
        (WidgetTester tester) async {
      // arrange
      when(mockApiService.fetchTips()).thenAnswer((_) async => []);
      when(mockApiService.addTip(any)).thenAnswer((_) async => null);

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'New Tip');
      await tester.tap(find.text('Post'));
      await tester.pumpAndSettle();

      // assert
      verify(mockApiService.addTip(any)).called(1);
    });

    testWidgets('should show edit tip dialog when edit button is pressed',
        (WidgetTester tester) async {
      // arrange
      final tips = [Tip(id: 1, description: 'Test Tip')];
      when(mockApiService.fetchTips()).thenAnswer((_) async => tips);
      when(mockApiService.updateTip(any, any)).thenAnswer((_) async => null);

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      // assert
      expect(find.text('Edit Tip'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Update'), findsOneWidget);
    });

    testWidgets('should update tip when edit dialog is submitted',
        (WidgetTester tester) async {
      // arrange
      final tips = [Tip(id: 1, description: 'Test Tip')];
      when(mockApiService.fetchTips()).thenAnswer((_) async => tips);
      when(mockApiService.updateTip(any, any)).thenAnswer((_) async => null);

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Updated Tip');
      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle();

      // assert
      verify(mockApiService.updateTip(1, 'Updated Tip')).called(1);
    });

    testWidgets('should show delete confirmation dialog when delete button is pressed',
        (WidgetTester tester) async {
      // arrange
      final tips = [Tip(id: 1, description: 'Test Tip')];
      when(mockApiService.fetchTips()).thenAnswer((_) async => tips);
      when(mockApiService.deleteTip(any)).thenAnswer((_) async => null);

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // assert
      expect(find.text('Delete Tip'), findsOneWidget);
      expect(find.text('Are you sure you want to delete this tip?'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('should delete tip when delete is confirmed',
        (WidgetTester tester) async {
      // arrange
      final tips = [Tip(id: 1, description: 'Test Tip')];
      when(mockApiService.fetchTips()).thenAnswer((_) async => tips);
      when(mockApiService.deleteTip(any)).thenAnswer((_) async => null);

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // assert
      verify(mockApiService.deleteTip(1)).called(1);
    });

    testWidgets('should cancel delete when cancel is pressed',
        (WidgetTester tester) async {
      // arrange
      final tips = [Tip(id: 1, description: 'Test Tip')];
      when(mockApiService.fetchTips()).thenAnswer((_) async => tips);

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // assert
      verifyNever(mockApiService.deleteTip(any));
      expect(find.text('Test Tip'), findsOneWidget); // Tip should still be visible
    });
  });
} 