import warnings
# Hiding all warnings
warnings.filterwarnings("ignore")
import pandas as pd
from faker import Faker
from datetime import datetime, timedelta
import time

fake = Faker('id_ID')

import random

# Function to generate random data with proportional distribution
def proportional_random(data_to_random, data_total, lower_bound_weight=10, upper_bound_weight=15):
    # Generating random proportions for each element
    weights = [random.randint(lower_bound_weight, upper_bound_weight) for _ in range(len(data_to_random))]
    # Selecting data randomly with specific proportions
    data_selected = random.choices(data_to_random, weights=weights, k=data_total)
    
    return data_selected

# Function to generate fake phone numbers
def generate_fake_phone_number():
    # Generating 9 random digits as a phone number
    phone_number = ''.join([str(random.randint(0, 9)) for _ in range(10)])
    
    # Combining country code and phone number
    fake_phone_number = '08' + phone_number
    
    return fake_phone_number

# Function to generate a random title for a car product
def random_title(model, year):
    list_used_cars = [f"Dijual mobil {model} tahun {year}, kondisi sangat terawat. Siap antar jalan-jalan keluarga!",
        f"Dijual mobil {model} tahun {year}, pemakaian pribadi, kilometer rendah. Jaminan performa dan kenyamanan!",
        f"Dijual mobil {model} tahun {year}, tampilan stylish dan performa tangguh. Siap temani petualanganmu!",
        f"Dijual mobil {model} tahun {year}, ruang interior luas untuk keluarga. Dijamin nyaman dan ekonomis!",
        f"Dijual mobil {model} tahun {year}, kuat dan andal di segala medan. Cocok untuk petualangan di alam terbuka!",
        f"Dijual mobil {model} tahun {year}, tangguh dengan desain elegan. Siap menemani perjalananmu!",
        f"Dijual mobil {model} tahun {year}, gabungan sempurna antara performa dan kemewahan. Pengalaman berkendara yang luar biasa!",
        f"Dijual mobil {model} tahun {year}, desain kompak dengan fitur canggih. Solusi tepat untuk mobilitas perkotaan!",
        f"Dijual mobil {model} tahun {year}, gaya modern dengan teknologi terkini. Dijamin memikat perhatian di jalan!",
        f"Dijual mobil {model} tahun {year}, simbol kemewahan dan prestise. Pengalaman berkendara yang tak terlupakan!"
    ]

    random_index = random.randint(0, len(list_used_cars)-1)
    random_title = list_used_cars[random_index]
    return random_title

# Function to generate a random title based on product details
def random_title_based_on_product_id(product_detail, product_detail_id):
    model = product_detail[product_detail['product_detail_id'] == product_detail_id]['model'].values[0]
    year = product_detail[product_detail['product_detail_id'] == product_detail_id]['year'].values[0]

    result = random_title(model, year)
    return result

# Function to establish one-step relation between tables
def relation_one_step(table_to, from_column, to_column, from_value):
    result = table_to[table_to[from_column] == from_value][to_column].values[0]
    return result

# Function to establish two-step relation between tables
def relation_two_step(table_to_step_1, table_to_step_2, from_column, to_column_step_1, to_column_step_2, from_value):
    result_step_1 = relation_one_step(table_to_step_1, from_column, to_column_step_1, from_value)
    result_step_2 = relation_one_step(table_to_step_2, to_column_step_1, to_column_step_2, result_step_1)
    return result_step_2

# Function to generate a bid price for a product
def bid_product_price(product_id):
    product_id_price = relation_two_step(product, product_detail, 'product_id', 'product_detail_id', 'price', product_id)
    price_after_bid = product_id_price * random.randint(8500, 9500) * 0.0001
    return int(price_after_bid)

# Function to generate a random bid date for a product
def random_date_bid(product_id):
    date_post = relation_one_step(product, 'product_id', 'date_post', product_id)
    date_bid = date_post + timedelta(days=random.randint(1, 365))
    return date_bid.strftime("%Y-%m-%d")

if __name__ == "__main__":
    print("Start creating dummy dataset ")

    # Start and end dates
    date_start = datetime(2022, 2, 25)
    date_end = datetime(2023, 2, 25)

    # Reading city and product detail data
    city = pd.read_csv('../dummy_dataset_from_pacmann/city - city.csv')
    city = city.rename(columns={'kota_id': 'city_id', 'nama_kota': 'city_name'})
    product_detail = pd.read_csv("../dummy_dataset_from_pacmann/car_product - car_product.csv").rename(columns={'product_id': 'product_detail_id'})
    city_id = city['city_id'].values
    product_detail_id = product_detail['product_detail_id'].values

    # Creating seller dataset
    seller = pd.DataFrame()
    total_seller = 150
    seller['seller_id'] = [i+1 for i in range(total_seller)]
    seller['seller_name'] = [fake.name() for i in range(total_seller)]
    seller['seller_contact'] = [generate_fake_phone_number() for i in range(total_seller)]
    seller['city_id'] = proportional_random(city_id, total_seller)
    seller_id = seller['seller_id'].values

    # Creating buyer dataset
    buyer = pd.DataFrame()
    total_buyer = 150
    buyer['buyer_id'] = [i+1 for i in range(total_buyer)]
    buyer['buyer_name'] = [fake.name() for i in range(total_buyer)]
    buyer['buyer_contact'] = [generate_fake_phone_number() for i in range(total_buyer)]
    buyer['city_id'] = proportional_random(city_id, total_buyer)
    buyer_id = buyer['buyer_id'].values

    # Creating product dataset
    product = pd.DataFrame()
    total_product = 1500
    product['product_id'] = [i+1 for i in range(total_product)]
    product['product_detail_id'] = proportional_random(product_detail_id, total_product)
    product['seller_id'] = proportional_random(seller_id, total_product)
    product['title'] = [random_title_based_on_product_id(product_detail, product['product_detail_id'].iloc[i]) for i in range(total_product)]
    product['date_post'] = [fake.date_between_dates(date_start=date_start, date_end=date_end) for i in range(total_product)]
    product_id = product_id = product['product_id'].values

    # Creating bid dataset
    bid = pd.DataFrame()
    total_bid = 1500
    bid['bid_id'] = [i+1 for i in range(total_bid)]
    bid['product_id'] = proportional_random(product_id, total_bid)
    bid['buyer_id'] = proportional_random(buyer_id, total_bid, 100, 110)
    bid['date_bid'] = bid['product_id'].apply(random_date_bid)
    bid['bid_price'] = bid['product_id'].apply(bid_product_price)
    bid_status = ['Sent', 'Declined']
    bid['bid_status'] = proportional_random(bid_status, total_bid)

    # Exporting datasets to CSV files
    city.to_csv('../dummy_dataset/city.csv', index=False)
    product_detail.to_csv('../dummy_dataset/product_detail.csv', index=False)
    seller.to_csv('../dummy_dataset/seller.csv', index=False)
    buyer.to_csv('../dummy_dataset/buyer.csv',index=False)
    product.to_csv('../dummy_dataset/product.csv', index=False)
    bid.to_csv('../dummy_dataset/bid.csv', index=False)

    print("Dummy dataset has been created")
    time.sleep(3)
