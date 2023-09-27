import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jendela_dbp/stateManagement/cubits/AuthCubit.dart';
import 'package:jendela_dbp/view/authentication/signup.dart';
import 'package:mockito/mockito.dart';


void main() {
  testWidgets('Test SignUp Button', (WidgetTester tester) async {
    // Create a mock AuthCubit with a mocked signup function
    final authCubit = AuthCubit();

    // Build your app with the mocked AuthCubit
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Signup(), // Replace with your form widget
        ),
      ),
    );

    // Simulate a form fill with valid data
    await tester.enterText(find.byKey(const Key('username_field')), 'TestUser');
    await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
    await tester.enterText(find.byKey(const Key('password_field')), 'password');
    await tester.enterText(find.byKey(const Key('confirm_password_field')), 'password');

    // Tap the sign-up button
    await tester.tap(find.byKey(const Key('sign_up_button')));

    // Rebuild the widget to reflect the changes
    await tester.pump();

    // Ensure that the AuthCubit's signup function is called after tapping the button
    verify(authCubit.signup('TestUser', 'test@example.com', 'password', 'password')).called(1);
  });
}
