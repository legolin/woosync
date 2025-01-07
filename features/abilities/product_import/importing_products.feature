Feature: Importing Products

  Scenario: Importing a simple list of products
    Given a simple update feed configured with mappings:
      | input_field       | output_field | enabled | import_method |
      | SKU               | sku          |       1 | simple        |
      | Name              | title        |       1 | simple        |
      | Short description | description  |       1 | simple        |
    When I import "product_feeds/honey-run-simple.csv"
    Then I have products:
      | sku  | title      | description_contains                                                          |
      | 1867 | Kenton Bed | This mid century modern bed futures the finest our Amish craftsmen can offer. |
