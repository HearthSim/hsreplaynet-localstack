def get_docker_host_ip():
	import subprocess
	p = subprocess.Popen(["ip", "route"], stdout=subprocess.PIPE)
	route = p.communicate()[0].decode().splitlines()[0]
	assert route.startswith("default via ")
	return route.split()[2]


SECRET_KEY = "hunter2"

DEFAULT_FILE_STORAGE = "django.core.files.storage.FileSystemStorage"

DEBUG = True
ALLOWED_HOSTS = ["*"]
INTERNAL_IPS = ["127.0.0.1", "::1", "10.0.2.2", get_docker_host_ip()]

ACCOUNT_DEFAULT_HTTP_PROTOCOL = "http"


DATABASES = {
	"default": {
		"ENGINE": "django.db.backends.postgresql",
		"NAME": "postgres",
		"USER": "postgres",
		"PASSWORD": "",
		"HOST": "db",
		"PORT": "",
	},
	"mercenaries": {
		"ENGINE": "django.db.backends.postgresql",
		"NAME": "postgres",
		"USER": "postgres",
		"PASSWORD": "",
		"HOST": "db",
		"PORT": "",
	},
	"uploads": {
		"ENGINE": "django.db.backends.postgresql",
		"NAME": "postgres",
		"USER": "postgres",
		"PASSWORD": "",
		"HOST": "db",
		"PORT": "",
	}
}


REDSHIFT_DATABASE = {
	"ENGINE": "postgresql",
	"NAME": "dev",
	"USER": "postgres",
	"PASSWORD": "",
	"HOST": "redshift",
	"PORT": 5432,
	"OPTIONS": {
		"sslmode": "disable",
	}
}


DYNAMODB_TABLES = {
	"battlegrounds_game_summary": {
		"MODEL": "hsreplaynet.battlegrounds.dynamodb.BattlegroundsGameSummary",
		"NAME": "battlegrounds_game_summary",
		"HOST": "http://localstack:4569/"
	},
	"constructed_game_summary": {
		"MODEL": "hsreplaynet.constructed.dynamodb.ConstructedGameSummary",
		"NAME": "constructed_game_summary",
		"HOST": "http://localstack:4569/"
	},
	"twitch_vod": {
		"MODEL": "hsreplaynet.vods.models.TwitchVod",
		"NAME": "twitch_vod",
		"HOST": "http://localstack:4569/"
	},
        "game_replay": {
		"MODEL": "hsreplaynet.games.models.dynamodb.GameReplay",
		"NAME": "game_replay",
		"HOST": "http://localstack:4569/"
	}
}


CACHES = {
	"default": {
		"BACKEND": "redis_lock.django_cache.RedisCache",
		"LOCATION": "redis://redis:6379/0",
		"OPTIONS": {
			"CLIENT_CLASS": "django_redis.client.DefaultClient",
		}
	},
	"redshift": {
		"BACKEND": "redis_lock.django_cache.RedisCache",
		"LOCATION": "redis://redis:6379/1",
		"OPTIONS": {
			"CLIENT_CLASS": "django_redis.client.DefaultClient",
			"COMPRESSOR": "django_redis.compressors.zlib.ZlibCompressor",
			"SERIALIZER": "django_redis.serializers.json.JSONSerializer",
		}
	}
}

additional_caches = (
	"live_stats",
        "battlegrounds_game_summary",
	"deck_prediction_primary",
	"deck_prediction_replica",
	"throttling",
	"ilt_deck_prediction"
)

for i, c in enumerate(additional_caches):
	CACHES[c] = CACHES["redshift"].copy()
	CACHES[c]["location"] = f"redis://redis:6379/{i+2}"


PREMIUM_PRODUCT_ID = 1
BATTLEGROUNDS_PRODUCT_ID = 2

XSOLLA_COMBO_MONTHLY_PLAN_ID = 1
XSOLLA_COMBO_SEMIANNUAL_PLAN_ID = 2

TWITCH_OAUTH_CLIENT_SECRET = "twitch-oauth-client-secret"

# This is the id for the Xsolla "product" that represents the new "combo" subscription for
# both the classic premium product and the new Battlegrounds product.
COMBO_XSOLLA_PRODUCT_ID = 3

STRIPE_LIVE_MODE = False
STRIPE_TEST_PUBLIC_KEY = "pk_test_123"
STRIPE_TEST_SECRET_KEY = "sk_test_123"
STRIPE_PUBLIC_KEY = STRIPE_TEST_PUBLIC_KEY
STRIPE_SECRET_KEY = STRIPE_TEST_SECRET_KEY
DJSTRIPE_USE_NATIVE_JSONFIELD = True

MONTHLY_PLAN_ID = "hearthsim-pro-monthly"
SEMIANNUAL_PLAN_ID = "hearthsim-pro-semiannual"

PAYPAL_CLIENT_ID = "foo"
PAYPAL_CLIENT_SECRET = "bar"
PAYPAL_MODE = "sandbox"

PAYPAL_MONTHLY_PLAN_ID = ""
PAYPAL_SEMIANNUAL_PLAN_ID = ""


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

STRIPE_API_HOST = "http://stripe:12111"

BATTLEGROUNDS_PREMIUM_OVERRIDE = True

SQS_REPROCESSING_QUEUE_NAME = "hsreplaynet-uploads-reprocessing"
SQS_REPROCESSING_QUEUE_URL = "https://localhost:4576/12345/hsreplaynet-uploads-reprocessing"

UNTAPPED_QUERY_CATALOGUES = {
	"mercenaries": {
		"executor": {
			"BACKEND":
				"untapped.query.django.execution.DefaultSynchronousQueryExecutorConfiguration",
			"DIALECT": "postgresql",
			"NAME": "postgres",
			"HOST": "db",
			"PORT": "5432",
			"USER": "postgres",
			"PASSWORD": ""
		},
		"store": {
			"BACKEND": "untapped.query.django.storage.LocMemQueryResultStoreBackend"
		}
	}
}

QUERY_REFRESH_SQS_QUEUE_URL = \
	"https://localhost:4576/12345/hsreplaynet-mercenaries-query-refresh"
