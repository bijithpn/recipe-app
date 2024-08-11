import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:recipe_app/core/constants/colors.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    // Name Field
                    FormBuilderTextField(
                      name: 'name',
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    // Date of Birth Field
                    FormBuilderDateTimePicker(
                      name: 'dob',
                      initialDate: DateTime(2000),
                      inputType: InputType.date,
                      decoration: const InputDecoration(
                        labelText: 'Date of Birth',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    // Email Field
                    FormBuilderTextField(
                      name: 'email',
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email(),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    // Password Field with Show/Hide Button
                    FormBuilderTextField(
                      name: 'password',
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      obscureText: _obscurePassword,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(6),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    // Confirm Password Field with Show/Hide Button
                    FormBuilderTextField(
                      name: 'confirm_password',
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      obscureText: _obscureConfirmPassword,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(6),
                        (val) {
                          if (_formKey.currentState != null) {
                            if (val !=
                                _formKey.currentState!.value['password']) {
                              return 'Passwords do not match';
                            }
                          }
                          return null;
                        },
                      ]),
                    ),
                    const SizedBox(height: 20),
                    // Register Button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.saveAndValidate()) {
                          final name = _formKey.currentState!.value['name'];
                          final dob = _formKey.currentState!.value['dob'];
                          final email = _formKey.currentState!.value['email'];
                          final password =
                              _formKey.currentState!.value['password'];
                          print(
                              'Name: $name, DOB: $dob, Email: $email, Password: $password');
                          // Handle registration logic
                        }
                      },
                      style: ElevatedButton.styleFrom(),
                      child: Text('Register',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Already have an account? Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to Login Screen
                    },
                    child: Text('Login here',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: ColorPalette.primary)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
