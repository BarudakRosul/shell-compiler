#!/bin/bash
#
# Author: FajarKim (Rangga Fajar Oktariansyah)
# GitHub: https://github.com/FajarKim
#
# shell-compiler: compressor for Shell Unix executables.
# Use this only for binaries that you do not use frequently.
#
# I try invoking the compressed executable with the original name
# (for programs looking at their name).  We also try to retain the original
# file permissions on the compressed file.  For safety reasons, bzsh will
# not create setuid or setgid shell scripts.
#
# WARNING: the first line of this file must be either : or #!/bin/bash
# The : is required for some old versions of csh.
# On Ultrix, /bin/bash is too buggy, change the first line to: #!/bin/bash5
#
skip=77
set -e

tab='	'
nl='
'
IFS=" $tab$nl"

# Make sure important variables exist if not already defined
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~$USER)}"
umask=`umask`
umask 77

lztmpdir=
trap 'res=$?
  test -n "$lztmpdir" && rm -fr "$lztmpdir"
  (exit $res); exit $res
' 0 1 2 3 5 10 13 15

case $TMPDIR in
  / | */tmp/) test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  */tmp) TMPDIR=$TMPDIR/; test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  *:* | *) TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
esac
if type mktemp >/dev/null 2>&1; then
  lztmpdir=`mktemp -d "${TMPDIR}lztmpXXXXXXXXX"`
else
  lztmpdir=${TMPDIR}lztmp$$; mkdir $lztmpdir
fi || { (exit 127); exit 127; }

lztmp=$lztmpdir/$0
case $0 in
-* | */*'
') mkdir -p "$lztmp" && rm -r "$lztmp";;
*/*) lztmp=$lztmpdir/`basename "$0"`;;
esac || { (exit 127); exit 127; }

case `printf 'X\n' | tail -n +1 2>/dev/null` in
X) tail_n=-n;;
*) tail_n=;;
esac
if tail $tail_n +$skip <"$0" | lzma -cd > "$lztmp"; then
  umask $umask
  chmod 700 "$lztmp"
  (sleep 5; rm -fr "$lztmpdir") 2>/dev/null &
  "$lztmp" ${1+"$@"}; res=$?
else
  printf >&2 '%s\n' "Cannot decompress ${0##*/}"
  printf >&2 '%s\n' "Report bugs to <barudakrosul22garut@gmail.com>."
  (exit 127); res=127
fi; exit $res
]   �������� �BF=�j�g�z��"�gV�>�5I��D����k̅�LH}v�OP.�� �p1M�,�3T�S��`>� �^����RKuy0��!?�c}�6��[�|�,%�F�m�r�[ߠ��'�VG#�ϸ��H��x������O�
�&�F(+�R�f&8� F~�<�>��q݂.�x���'���B�f-'��پ֮�f�\d'�`ނ$��ߴ�j��H!�ҽx,�/m�˱e��M��/��A���Z��`�4H�3����/6H����eo=�7Ԝ,���jm�_��XB��HT�m��a�@F�@_@	Zo� z����dm��K`�g��5�ב���Y=�!�k�7k��X�W�$����B�h�BH�98�����f�,����u(��<�f�H��`LpЦ�yl�U�Ӹ��G��ޥ%�����)�"�[����0A�W��]���$�e哊��R{ai���ŉy,���}�B��נ�q������Y��3b�'W�� ��(s���S�خ�q~�n�O:�a��it^����Jn3�����2ؘNc��^,ܲ�-�'`,��z�����Z�����t9Z[7Pt?��Gf�{�J�47��Z��ws~R��YP�Y	�O Z��>�Z�zi��&�VM��ޯ� ��\�������8��)z�e�&�4���Hx���sw��x[�Z���<
��/�k�B�J�:;�y�g���a���Q�o�{"ăg�E��h��B�^�=uu�P�:Iy����fHUq��E���Ff	�ܶ!�����7f�lY�y�J\t.;��E|pסc㝝򎋻@�c����N���9J���X����9�|W�옪���f��*\\�f�b9�P_�#^m"��:`|G}0<�B���;�ztA�Kt�g.���9K��$e���F�R�T�C�+�^V�5��>����;/<DeQ
���Z���T���� �t��o��[Ѭ�A$�^N��`H&���j�`)�U�R��jۆr+��9{�!�y.�XW'A?���>y����Z�S3��#�7^�P%q��Ʒ�z� ��s<�S�f�����v ^��?�?�����+�~�h}�l��놂�+o*�T�=�^�yڼ�7D�儬D��)���#m���)s� I��Ș�5�g��F�a�@dH�my,��g�e=(���@����N.��k�<�L��U��lX��i2����_⠽���"ʩ�ݏ�&��"i��{f��������f�CQ��`�,lJ����ɃÒ'�X.:�Ml���u%�;%�1�L�=	XRz��Zȯ��t�����ц���`�~��D �s�!�-����sb��?�S���d)����Aʅ����\��Y��?�Y�~5J�b=m}b:�A��?K�QS"��$C���? [��i�<��-��f�#���<�[�6o���S��*��L;�.��H����!m6ɇ�Ow�Θ�w�������=��'�M�G�_�q�}i>C�:���W{5�5$�@`�3@�+�T�!�Ij��ѴQ�,�pi]A�k3J�I���A�Y-�ܦ���.`;���� ��ꢉ��;�>�;����8f����e3�A�ܮ|2k�y@��r��Q2�a�?�+ڱŮ�]`Jz\�Z�p�T�R'��bQ]�w&6��>]�󳹣�T"!<�׉@����S u=u�T]r7�rF��#0��E���x��ɡ�K21�ӛeN�ɕ��i��d�a�
 pLE�����L^A~���`pH�. ��cǺS�lT{�U�1���@���
[Ĕ����$��ؠÚt_���˽U�_T������M��h �wRJ�ɵs�����^a�v@@��z#�qv�R+c�D0�j��� !Q~���8c�M=��D$�%)����S�$��6[k(.���-�©Ϲ��-�G����oQH��Щ#���[0�@�3#�kW�&�s!���VauxcJGa9�\��c
Ye�AZ���\�y--����$�a.����:H��4�ѣ��q��R�R�|6ZK10��y�6�C�'Ҝ���W�&)/)�De���K	-�/��ݹG�"�Wk�L/Lf���{Y_��T(at����Ǣwf'Y�˺�5C�k\H#L�">��"0��]�����1��l�4m��C�k�����,�u0��ՠ=W�%F%���5������UJ�9-;�A,v��p/i�W�ɉA�{!�m�x޴ȴ4���:�Zk��Dã�Hv�F�yM<�xk-1�=��}+Tcg�'��^'����6�q|{�[��,b��D 9�r]�r(��.�ՉX�PS}��40)E�x5�?��2��/<�YQ�~.��Is���x���|��4���;'���8�[pݍ]�J�$�;��	����6�z�Έ���3W���S՛��Q��C�Y͗ya�#��L� ;m�'�l�6�7��4Xh)�<��w�N'(~]tNH�BO0���S�A6D���ֻ�u!�|yy���M�D<X�u7:F�W����L���.ր��m����4��sGB��@"ǁE!�p*�z:��x���k����e��h�����`!��jʀ�Ol��-�dD�h�<�#�4�;ut�Ρ�od.��R<���ݏaW�������!�(<,L7}�-R�����F�#;��L��v���j"���:q�f��'CP����5��5)�Η�؉��۩�f�]Y�����J��-������a&i�&����Ľ���~�o��L�L/9����b�E�ZR(h�}�+�Q����R��NF��q��,[�r����)��Pqʦf�/�im9G�8���[L�h�/aPtyZY,������h42���e^�羻�.�	a*E��~_��u78�ոcI ���y"��/�Z�r.���1i+�^.���Ѻ��.��ʍ2��� ��K��S6S���P��uTn�جITA��L�3t�"[!1�%ZL�S-]8(���$���i�P��J[V�"��l�c�Č�g����1j5���{$E��D�F��ʂ���/����G)%dS���^��ְl��vݗ}>�D�����<��-1�����%(��:�і���6����ȱ��:���R�Qw�l�SnJ�|:��=�N~�Kݰf3:�;��Z��U�<��ʗ��4��9�OK�@\8x�ҧ_�T�Z1���� �d��a��]E����@f�"N�ut	��U������"k��)�o�$=#�������_�V;x�Dh�H����A�|iu���V���
���=�f�I� �N�C�YK�`SL|"�����Vf�š���Y�ͥ���u���Ѧ��6����ډN�d2���,�M��ۓ�� s�^����Lt�&Mhz�
���Irɐq���ȼ�Fmbe��#��&V,��ݮa����	�W�J�ŷE���K�G�X�B-R�x��F���x���N�lWo��Ԙp���o7��ÃKl2ɫ�Y�ٵ-3�7�l�)�2���]<	�K��ﱲElE>�-���L���;��ܘ�d�����O5	 {b�
�? f��1��[Ty3k�z�T�:��4��}�*���� ���ו�Z�{UF#��3��u؝��~r�9�!Z"', U�@�xr=�ur��K�Xa�3�ɵΰ�!�Kvy�T/��V�W��ti�,��۔{�tJ4H[A��"ǫNSX��� S�]�Q(q��I�7z���"
Ts9�Я�o�-E){�wQ�T�����N%y�]�3V5�{�<����}0�p0�}�I	������U|+�#&*���D-&>H��&�p���N��Q3ѯ�i���x���g��g�N��vyb�H>L���Ҳ6�&��u�W���7�����;�zp��Z�/SHI���>���@���5�lY�p�YLAI榉�'<����ܽ�J 3�IS���C�=���#>�U�0v(��"�ɱ"��A�q��_����oׂ,�"x�U�$�kf�1ӭ���߬�x1���ʁ�0-��Z����K۩���:@��"���!��yY �At��hKzdR�_�tj�����Z��ۼb��(�|� 4Y��~U����,��ҠC��Bp�4?��I�h����k�0���xYZ��n���c��YSWe������i���E�>������=<OX�X�z{�*Q���S�[��!*�gK���h��ڹ�m�z�e����t�͂�P^��S�Ex|� �#��O~��ɓ&�=V'}$큹P�|檀�~�h0:G	���P��X�0�,,՝M��ADǕMQ�1:���J�{�cQ>_NX��_?����qh����H�,��X2f<Ng�D�/ؠ1�r2��J�B��p�jcֈ��@��۪u��Խ�D*���9�C�'�K <c�0F�O��m��L(e�*�=��t$��s�I�KL�g sV2l�(����|�Z���R&�!�������mX|�@Q-&V����,�y�a�̀	AJ��e\lG��s�*�*O���o��;݉�y��QeS���ST�s�x
m�j�\�:�f�"U����ׯ���A����s*��ɭt
$^@����p�f�d�@NHCL�v=W�g�q���@u=[^���>�Z8�&ӌj�����$oY�՛��K�Z}�W�t,I�ƠK?dT+�NM�;$?���h�͢3�UF�����pw�����-�8�9�֧��.��ٖ�}b�)��pD���;�I��j���j�Qa�:�/m�wc�i�)j �� ��(e-�t�~h��+�(K`ڱ���ꅼP��o�L��' �-
��鲄� %/[��H�c�9�Ze�,� jvZX��M�УC*�����H�?�x�=9��>���8�A-1���]�1MA�GqreE�\�
ʫ;Li�͸���zs3I7g��m�ՋŰ�س�ש+�ɭdm'գ��k!�=�ԠÙ;�p� 9��ݗ+ۓ�(1-���V�0q��c���h����8x�P #$J����݄|��~���Wgi�
}q�Ί����w� W��J��������ɦ��&��.����F0���G�C��;��Xpy��J@���7t�����Z'�����'K��Yq�&�������:@�2��U��-wΎΑ���$�'�F��(�e���I���A��M�o!���i��O��h�?�l�����·c+���N�Ex�5F��h]�(���g��:& Iv$�z���B�O����ܾ1�0��ߟ��(�L|-t�M���4�T��o�O��|l�]8�nX*i�o*�X c�c��Z'��o^��ӓf��{����v�g��*���k��N\D��,���F�5�����>s���q]����Z����z�&��h��R��^��u܋�&P,�f�j�����kȷ���N��I�;%xA�Nr�w����P����/غ�a�Dd�te9e]iګ����