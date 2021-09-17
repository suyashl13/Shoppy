import React, { useEffect, useContext } from 'react'
import { Link } from 'react-router-dom'
import { toast } from 'react-toastify'
import { productContext } from '../../contexts/ProductContext'
import { getProductsFromBackend } from '../../helpers/BackendProductHelper'

export default function SubdealerProductsPage() {

    const { product, setProduct } = useContext(productContext)

    useEffect(() => {
        if (product == null) {
            console.log("called")
            getProductsFromBackend({
                onSuccess: (data) => {
                    setProduct(data);
                },
                onError: (err) => {
                    toast('Something went wrong while fetching products.', { type: 'error' });
                }
            })
        }
    }, [])

    const refresh = async () => {
        getProductsFromBackend({
            onSuccess: (data) => {
                setProduct(data)
            },
            onError: () => {
                toast('Something went wrong while fetching products.', { type: 'error' });
            }
        })
    }

    return (
        <div className='container p-4'>
            <br />
            <div className="row">
                <div className="col-sm-12 col-md-8 mb-5">
                    <div style={{
                        display: 'flex',
                        flexDirection: 'row',
                        justifyContent: 'space-between',
                        alignItems: 'center'
                    }}>
                        <h3 className='mb-4'>My Products</h3>
                        <span className='mb-2 text-primary' style={{
                            userSelect: 'none'
                        }} onClick={e => { refresh() }} >Refresh</span>
                    </div>
                    <div className="row">
                        {
                            product?.products?.map((val, i) =>
                                <div key={i} className="col-lg-6 col-md-6 col-sm-12">
                                    <div className='card mb-2'>
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
                        {product?.categories.map((val, i) => <li key={i} className='list-group-item'>
                            {val?.name}
                        </li>)}
                    </ul>
                    <center>
                        <Link className='nav-link active mt-3' to='/products/new/add'>Add New Product</Link>
                    </center>
                </div>
            </div>
        </div>
    )
}
