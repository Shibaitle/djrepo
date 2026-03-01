set -o errexit

pip install -r requirements.txt
python manage.py collectstatic --no-input
python manage.py migrate

cat <<EOF | python manage.py shell
import os
from django.contrib.auth import get_user_model
User = get_user_model()

sys_user = os.environ.get('MY_ADMIN_USER')
sys_email = os.environ.get('MY_ADMIN_EMAIL')
sys_pass = os.environ.get('MY_ADMIN_PASS')

if sys_user and sys_pass:
    if not User.objects.filter(username=sys_user).exists():
        User.objects.create_superuser(sys_user, sys_email, sys_pass)
        print(f"Superuser '{sys_user}' created successfully!")
    else:
        print(f"Superuser '{sys_user}' already exists.")
else:
    print("Environment variables for superuser are missing")
EOF