function ngDateHelper() {
    return {
        getCurrentDate: function(){
            return new Date();
        },

        getCurrentYear: function(){
            return this.getCurrentDate().getFullYear();
        },

        getCurrentMonth: function(){
            return (this.getCurrentDate().getMonth() + 1);
        }
    }
}