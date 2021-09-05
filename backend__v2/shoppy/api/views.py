from django.http.response import JsonResponse


# Create your views here.
def home(request):
    return JsonResponse({'INFO': 'HOME'})
