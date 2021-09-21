import React, { useState } from "react";
import Picture from "./Picture";
import { AiFillHeart } from "react-icons/ai";
const Product = ({ item, showModal, user, addToCart, addFav, deleteFav }) => {
  const handleFav = () => {
    let allItems = {
      name: item.name,
      price: item.price.value,
      url: item.images[0].url,
    };
    fetch("http://localhost:9292/fav", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        user: user.user_name,
        name: item.name,
        price: item.price.value,
        url: item.images[0].url,
      }),
    });
    addFav(allItems);
  };

  const handleClick = (key) => {
    fetch(`http://localhost:9292/user/${user.user_name}/cart/${key}`)
      .then((resp) => resp.json())
      .then((data) => console.log(data.quantity));
    addToCart({
      name: item.name,
      price: item.price.value,
      url: item.images[0].url,
    });
    fetch(`http://localhost:9292/user/${user.user_name}/cart`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        user: user.user_name,
        name: item.name,
        price: item.price.value,
        url: item.images[0].url,
        quantity: null,
      }),
    });
  };

  return (
    <li className="shadow">
      <Picture
        pic={item.images ? item.images[0].url : item.url}
        id={new Date().getTime()}
      />
      <h4>{item.name}</h4>
      <h5>${item.price.value}</h5>
      {/* <ul style={{ display: "grid" }}>
        {item.rgbColors.map((color) => {
          return (
            <li style={{ display: "inline" }}>
              <span>{color}</span>
            </li>
          );
        })}
      </ul> */}
      <button onClick={showModal}>Drag And Drop</button>
      <button onClick={handleClick}> Add To Cart</button>
      <button onClick={handleFav}>
        <AiFillHeart />
      </button>
    </li>
  );
};

export default Product;
