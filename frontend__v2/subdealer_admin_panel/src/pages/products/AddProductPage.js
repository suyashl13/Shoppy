import React, { useContext, useEffect, useState } from 'react'
import { useHistory } from 'react-router'
import { toast } from 'react-toastify'
import { productContext } from '../../contexts/ProductContext'
import { addProductAtBackend, getProductsFromBackend } from '../../helpers/BackendProductHelper'

export default function AddProductPage() {

    const { product, setProduct } = useContext(productContext)
    const [newProduct, setNewProduct] = useState({
        product_image: '', title: '', price: 0, unit: '', description: '', discount: 0, is_available: true,
        vendor_name: '', available_stock: '', tax_percentage: 0, base_price: 0, category: 1,
        product_image: null
    })

    const history = useHistory()

    const getSellingPrice = (base_price, discount, tax_percentage) => (parseFloat(tax_percentage / 100 * base_price) + parseFloat(base_price) - parseFloat(discount / 100 * base_price))

    useEffect(() => {
        if (product == null) {
            getProductsFromBackend({
                onSuccess: (data) => {
                    setProduct(data);
                },
                onError: (err) => {
                    toast('Something went wrong while fetching products.', { type: 'error' });
                }
            })
        }
    }, [product])

    return (
        <div className='container'>
            <div className="alert alert-info mt-4" role="alert">
                Please make sure you upload proper data / image elsewise your subdealer profile might get betrayed.
            </div>
            <center>
                <h3 className='p-3 mt-4 mb-3'>Add New Product</h3>
            </center>
            <form onSubmit={e => {
                e.preventDefault();
                addProductAtBackend({
                    onSuccess: (data) => { 
                        toast('Product uploaded successfully please refresh to see updated product list.')
                        history.push('/products')
                    },
                    onError: (err) => { console.log(err) }
                }, newProduct);
            }}>
                <div className="row">
                    <div className="form-group col-6">
                        <label htmlFor="product-name">Product Name</label>
                        <input required type="text" onChange={e => { setNewProduct({ ...newProduct, title: e.target.value }) }} value={newProduct.title} id="product-name" className="form-control" />
                    </div>
                    <div className="form-group col-6">
                        <label htmlFor="product-category">Category</label>
                        <select onChange={
                            e => setNewProduct({ ...newProduct, category: parseInt(e.target.value.split(' - ')[0]) })
                        }
                            id="product-category" className="form-control">
                            {
                                product?.categories.map((val, i) => <option key={i}>{val.id} - {val.name}</option>)
                            }
                        </select>
                    </div>
                </div>
                <div className="row">
                    <div className="form-group col-12">
                        <label htmlFor="product-description">Description</label>
                        <textarea required onChange={e => { setNewProduct({ ...newProduct, description: e.target.value }) }} value={newProduct.description} id="product-description" className="form-control" />
                    </div>
                </div>
                <div className="row">
                    <div className="form-group col-3">
                        <label htmlFor="product-base-price">Base Price (INR)</label>
                        <input required type='number' onChange={e => {
                            if (e.target.value < 0) {
                                setNewProduct({ ...newProduct, base_price: 0 })
                            } else {
                                setNewProduct({ ...newProduct, base_price: e.target.value })
                            }
                        }} value={newProduct.base_price} id="product-base-price" className="form-control" />
                    </div>
                    <div className="form-group col-3">
                        <label htmlFor="product-tax">Tax (%)</label>
                        <input required type='number' onChange={e => {
                            if (e.target.value < 0) {
                                setNewProduct({ ...newProduct, tax_percentage: 0 })
                            } else {
                                setNewProduct({ ...newProduct, tax_percentage: e.target.value })
                            }
                        }} value={newProduct.tax_percentage} id="product-tax" className="form-control" />
                    </div>
                    <div className="form-group col-3">
                        <label htmlFor="product-description">Discount (%)</label>
                        <input required type='number' onChange={e => {
                            if (e.target.value < 0) {
                                setNewProduct({ ...newProduct, discount: 0 })
                            } else {
                                setNewProduct({ ...newProduct, discount: e.target.value })
                            }
                        }} value={newProduct.discount} id="product-discount" className="form-control" />
                    </div>
                    <div className="form-group col-3">
                        <label htmlFor="product-price">Selling Price</label>
                        <input required type='number' disabled onChange={e => {
                        }} value={getSellingPrice(newProduct.base_price, newProduct.discount, newProduct.tax_percentage)} id="product-price" className="form-control" />
                    </div>
                </div>
                <div className="row">
                    <div className="form-group col-4">
                        <label htmlFor="product-vendor-name">Vendor Name</label>
                        < input required type='text' onChange={e => { setNewProduct({ ...newProduct, vendor_name: e.target.value }) }} value={newProduct.vendor_name} id="product-vendor-name" className="form-control" />
                    </div>
                    <div className="form-group col-4">
                        <label htmlFor="product-available-stock">Available Stock</label>
                        <input required type='number' onChange={e => {
                            if (e.target.value < 0) {
                                setNewProduct({ ...newProduct, available_stock: 0 })
                            } else {
                                setNewProduct({ ...newProduct, available_stock: e.target.value })
                            }
                        }} value={newProduct.available_stock} id="product-available-stock" className="form-control" />
                    </div>
                    <div className="form-group col-4 mt-4">
                        <div className="custom-file">
                            <input required type="file" onChange={e => {
                                setNewProduct({ ...newProduct, product_image: e.target.files[0] })
                            }} className="custom-file-input form-control" id="customFile" />
                        </div>
                    </div>
                </div>
                <br />
                <button type='submit' onClick={e => { getSellingPrice(newProduct.base_price, newProduct.discount, newProduct.tax_percentage) }} className="btn btn-primary">Upload Product</button><br />
            </form>
            <br />
        </div>
    )
}
