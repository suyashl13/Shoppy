import React, { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { toast } from 'react-toastify'
import { useContext } from 'react/cjs/react.development'
import { productContext } from '../../contexts/ProductContext'
import { getProductsFromBackend } from '../../helpers/BackendProductHelper'

export default function SubdealerProductsPage() {

    const { product, setProduct } = useContext(productContext)

    useEffect(() => {
        if (product == null) {
            console.log("called")
            getProductsFromBackend({
                onSuccess: (data) => {
                    setProduct(data)
                },
                onError: (err) => {
                    toast('Something went wrong while fetching products.')
                }
            })
        }
    }, [])

    return (
        <div className='container p-4'>
            <br />
            <div className="row">
                <div className="col-sm-12 col-md-8 mb-5">
                    <h3 className='mb-4'>Products</h3>
                    <div className="row">

                        {
                            product?.products?.map((val, i) =>
                                <div className="col-lg-6 col-md-6 col-sm-12">
                                    <div key={i} className='card mb-2'>
                                        <div className="card-head">
                                            <img src={val.product_image} alt="prod_img" className="cart-img img-fluid" />
                                        </div>
                                        <div className="card-body">
                                            <div style={{
                                                display: 'flex',
                                                flexDirection: 'row',
                                                alignItems: 'center',
                                                justifyContent: 'space-between'
                                            }} className="card-title fw-bold">{val.title} <span className={val.is_active ? "badge text-light bg-success" : "badge text-dark bg-warning"}>({val.is_active ? "Active" : "Not Active"})</span></div>

                                            <div className="card-text">Base Price : Rs. {val.base_price}</div>
                                            <div className="card-text">Tax : {val.tax_percentage}%</div>
                                            <div className="card-text">Discount : {val.discount}%</div>
                                            <div className="card-text">In Stock : {val.available_stock} Units</div>

                                            <Link to={`/products/${val.id}`} className="btn btn-sm btn-info mt-3">View Product</Link>
                                        </div>
                                    </div>
                                </div>)
                        }
                    </div>
                </div>
                <div className="col-sm-12 col-md-4">
                    <h3 className='mb-4'>Active Categories</h3>

                    <ul className="list-group">
                        {
                            product?.categories.map((val, i) => <li className='list-group-item'>
                                {val.name}
                            </li>)
                        }
                    </ul>
                </div>
            </div>
        </div>
    )
}
