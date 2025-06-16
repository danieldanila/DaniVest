const catchAsync = (asyncFuction) => {
    return (req, res, next) => {
        asyncFuction(req, res, next).catch((err) => next(err));
    };
};

export default catchAsync