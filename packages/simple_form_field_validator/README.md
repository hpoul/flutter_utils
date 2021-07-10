# simple_form_field_validator

Simple helper for easily validating form fields.

For example:

```
          TextFormField(
            controller: _email,
            decoration: const InputDecoration(
              labelText: 'Enter email address to register or sign in.',
              hintMaxLines: 2,
            ),
            keyboardType: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
            textInputAction: TextInputAction.send,
            validator: SValidator.notEmpty(
                        msg: 'Please enter a valid email address.') +
                    SValidator.email(msg: 'Please enter a valid email address.')
                as String? Function(String?)?,
          ),

```

