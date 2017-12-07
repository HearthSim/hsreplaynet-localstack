#!/usr/bin/env python
"""
Initialize a database with the following:

- An admin user, with the password 'admin'
- A non-admin user, with the password 'user'
- The default site set to localhost:8000
- The Battle.net social application set up

This script can safely be run multiple times.
"""

import django; django.setup()  # noqa
from allauth.socialaccount.models import SocialApp
from django.conf import settings
from django.contrib.auth import get_user_model
from django.contrib.flatpages.models import FlatPage
from django.contrib.sites.models import Site
from djstripe.models import Customer
from hearthsim.identity.accounts.models import AuthToken
from hearthsim.identity.api.models import APIKey


User = get_user_model()
API_KEY_NAME = "HSReplay.net Development Key"


def create_or_update_user(username, password, apikey, admin=False):
	user, created = User.objects.get_or_create(username=username)
	user.is_superuser = admin
	user.is_staff = admin
	user.set_password(password)
	user.email = username + "@hearthsim.local"
	user.save()

	# Associate a Stripe Customer with the user so we don't call the API...
	Customer.objects.get_or_create(
		subscriber=user, livemode=False,
		defaults={
			"stripe_id": f"cus_user_{user.pk}",
			"account_balance": 0, "delinquent": False
		}
	)

	# Associate an auth token with the user
	token, created = AuthToken.objects.get_or_create(
		user=user, creation_apikey=apikey,
	)

	return user, token


def update_default_site(site_id):
	site = Site.objects.get(id=site_id)
	site.name = "HSReplay.net (development)"
	site.domain = "localhost:8000"
	site.save()
	return site


def create_default_api_key():
	key, created = APIKey.objects.get_or_create(full_name=API_KEY_NAME)
	key.email = "admin@hearthsim.local"
	key.website = "http://localhost:8000"
	key.save()
	return key


def create_default_flatpage(url, title):
	page, created = FlatPage.objects.get_or_create(url=url, title=title)
	if not page.sites.count():
		page.sites.add(settings.SITE_ID)
	return page


def create_socialapp(provider, name):
	socialapp, created = SocialApp.objects.get_or_create(provider=provider)
	socialapp.name = name
	socialapp.save()
	if not socialapp.sites.count():
		socialapp.sites.add(settings.SITE_ID)
	return socialapp


def create_oauth2_application(name, homepage):
	from oauth2_provider.models import get_application_model

	Application = get_application_model()
	app, created = Application.objects.get_or_create(
		name=name, defaults={
			"client_type": "public",
			"authorization_grant_type": "authorization_code",
			"homepage": homepage,
		}
	)


def main():
	update_default_site(settings.SITE_ID)
	apikey = create_default_api_key()
	create_or_update_user("admin", "admin", apikey, admin=True)
	create_or_update_user("user", "user", apikey)
	create_default_flatpage("/contact/", "Contact Us")
	create_default_flatpage("/about/privacy/", "Privacy Policy")
	create_default_flatpage("/about/tos/", "Terms of Service")
	create_oauth2_application("Hearthstone Deck Tracker", "https://hsdecktracker.net")
	create_socialapp("battlenet", "Battle.net (development)")
	create_socialapp("discord", "Discord (development)")
	create_socialapp("twitch", "Twitch (development)")


if __name__ == "__main__":
	main()
