// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

// Nipals
List Nipals(SEXP Mat, SEXP params);
RcppExport SEXP gge_Nipals(SEXP MatSEXP, SEXP paramsSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< SEXP >::type Mat(MatSEXP);
    Rcpp::traits::input_parameter< SEXP >::type params(paramsSEXP);
    rcpp_result_gen = Rcpp::wrap(Nipals(Mat, params));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"gge_Nipals", (DL_FUNC) &gge_Nipals, 2},
    {NULL, NULL, 0}
};

RcppExport void R_init_gge(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
