from allauth.account.adapter import DefaultAccountAdapter


class CustomAccountAdapter(DefaultAccountAdapter):

    def save_user(self, request, user, form, commit=True):
        data = form.cleaned_data
        
        user = super().save_user(request, user, form, False)
       
        print(request.data)
        user.name = request.data["name"]
        user.phone = request.data["phone"]

        print(data.get("name"))
        print(data.get("phone"))
        user.save()
        return user
