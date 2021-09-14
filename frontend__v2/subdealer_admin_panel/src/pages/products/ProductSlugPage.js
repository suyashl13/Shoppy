import React, { useContext, useState } from 'react'
import { Redirect, useParams } from 'react-router'
import { productContext } from '../../contexts/ProductContext';
import { tConvert } from '../../helpers/DateTimeHelper';

export default function ProductSlugPage() {

    const { id } = useParams()
    const { product, setProduct } = useContext(productContext)
    const myProduct = product?.products.filter(e => e.id == id)[0];

    if (!myProduct) {
        return <Redirect to='/pagenotfound' />
    }

    return (
        <div className='container p-4'>
            {myProduct?.is_active ? null : <div className='alert alert-danger' role='alert'>
                The product is currently not visible to customers as it has not been verified by superadmins yet. As verification is done it will be visible to customers.
            </div>}
            <div className="row">
                <div className="col-sm-12 ">
                    <center><img src={myProduct?.product_image} alt="product_image" className="mt-4 rounded-circle mb-5" height='240' width='238' /></center>
                </div>
                <div className="col-sm-12 pt-1">
                    <table class="table table-bordered">
                        <tbody>
                            <tr>
                                <th scope="row">Product Title</th>
                                <td>{myProduct?.title}</td>
                            </tr>
                            <tr>
                                <th scope="row">Description</th>
                                <td>{myProduct?.description}</td>
                            </tr>
                            <tr>
                                <th scope="row">Available Stock</th>
                                <td >{myProduct?.available_stock} Units</td>
                            </tr>
                            <tr>
                                <th scope="row">Is Available</th>
                                <td >{myProduct?.is_available ? "Yes" : "No"}</td>
                            </tr>
                            <tr>
                                <th scope="row">Is Active</th>
                                <td >{myProduct?.is_active ? "Yes" : "No"}</td>
                            </tr>
                            <tr>
                                <th scope="row">Base Value</th>
                                <td>Rs. {myProduct?.base_price}</td>
                            </tr>
                            <tr>
                                <th scope="row">Discount</th>
                                <td >{myProduct?.discount}%</td>
                            </tr>
                            <tr>
                                <th scope="row">Date Created</th>
                                <td>{tConvert(myProduct?.date_time_created.split('T')[0])}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    );
}
