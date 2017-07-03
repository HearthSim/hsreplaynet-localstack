SECRET_KEY = "hunter2"

DEFAULT_FILE_STORAGE = "django.core.files.storage.FileSystemStorage"

DEBUG = True
ALLOWED_HOSTS = ["*"]
INTERNAL_IPS = ["127.0.0.1", "::1", "10.0.2.2"]

ACCOUNT_DEFAULT_HTTP_PROTOCOL = "http"


DATABASES = {
	"default": {
		"ENGINE": "django.db.backends.postgresql",
		"NAME": "hsreplaynet",
		"USER": "postgres",
		"PASSWORD": "",
		"HOST": "localhost",
		"PORT": "",
	},
	"uploads": {
		"ENGINE": "django.db.backends.postgresql",
		"NAME": "uploads",
		"USER": "postgres",
		"PASSWORD": "",
		"HOST": "localhost",
		"PORT": "",
	}
}

UPLOADS_DB = "uploads"
DATABASE_ROUTERS = ["hsreplaynet.utils.routers.UploadEventsRouter"]


# Cache (django-redis-cache)
# https://django-redis-cache.readthedocs.io/en/latest/intro_quick_start.html
CACHES = {
	"default": {
		"BACKEND": "redis_lock.django_cache.RedisCache",
		"LOCATION": "localhost:6379",
		"OPTIONS": {
			"CLIENT_CLASS": "django_redis.client.DefaultClient",
		}
	},
	"redshift": {
		"BACKEND": "redis_lock.django_cache.RedisCache",
		"LOCATION": "localhost:6379",
		"OPTIONS": {
			"CLIENT_CLASS": "django_redis.client.DefaultClient",
			"COMPRESSOR": "django_redis.compressors.zlib.ZlibCompressor",
			"SERIALIZER": "django_redis.serializers.json.JSONSerializer",
		}
	}
}


STRIPE_LIVE_MODE = False
STRIPE_TEST_SECRET_KEY = "sk_test_"
DJSTRIPE_USE_NATIVE_JSONFIELD = True

MONTHLY_PLAN_ID = "hearthsim-pro-monthly"
SEMIANNUAL_PLAN_ID = "hearthsim-pro-semiannual"


INFLUX_DATABASES = {
	"hsreplaynet": {
		"NAME": "hsreplaynet",
		"HOST": "localhost",
		"PORT": 8086,
		"USER": "",
		"PASSWORD": "",
		"SSL": False,
	},
	"joust": {
		"NAME": "joust",
		"HOST": "localhost",
		"PORT": 8086,
		"USER": "",
		"PASSWORD": "",
		"SSL": False,
	}
}


JOUST_RAVEN_DSN_PUBLIC = ""
JOUST_RAVEN_ENVIRONMENT = ""
