from django.db import models

# Create your models here.
# properties/models.py


class PropertyMetadata(models.Model):
    property_id = models.IntegerField(unique=True)
    description = models.TextField(blank=True)
