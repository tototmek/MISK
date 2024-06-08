from django.shortcuts import render

# Create your views here.
from django.urls import path
from . import views

urlpatterns = [
    path("create_property/", views.create_property, name="create_property"),
    path("get_properties/", views.get_properties, name="get_properties"),
]

from django.http import JsonResponse
from web3 import Web3
from .web3_handler import property_manager


def create_property(request):
    # Get data from request
    title = request.POST.get("title")
    info = request.POST.get("info")
    for_sale = bool(request.POST.get("for_sale"))
    price = int(request.POST.get("price"))

    # Interact with smart contract
    tx_hash = property_manager.functions.createProperty(
        title, info, for_sale, price
    ).transact({"from": Web3.toChecksumAddress(request.POST.get("from_address"))})

    return JsonResponse({"status": "Property created", "tx_hash": tx_hash.hex()})


def get_properties(request):
    properties = property_manager.functions.getAllProperties().call()
    return JsonResponse(properties, safe=False)
